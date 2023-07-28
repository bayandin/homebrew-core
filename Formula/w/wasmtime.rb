class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v12.0.1",
      revision: "6116aae3d4cdcc2ec9f385a0146a93240f009cca"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8277c83802794cd5fa15c04a854666db3d58e275fece2da261c190e26e9efb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02ccf3c08014e704932eab04731374494dbc722682bfb6e6705acdba1b29d8c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3698dd0bedcfd4e3684d6a3b961961f7716e1518937e53d237c27b01df9c88e2"
    sha256 cellar: :any_skip_relocation, ventura:        "bdd22d670e2e686ca28874f4c1bd82d814a41c1e69d1f45719fa174f1160f8a4"
    sha256 cellar: :any_skip_relocation, monterey:       "1a34c29b3ecd2982611a3e76dde852032ed5d9adae7f878c860c802b96b83f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6166197527167a7b9f63be61caef79518185d070cdb5fce8231e89197bfa5d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc9e13d6742f7bc9a44da193f5cc96d1b65af339ad6463e2f684141d8557d38f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "build", "--locked", "--lib", "--manifest-path", "crates/c-api/Cargo.toml", "--release"
    cp "crates/c-api/wasm-c-api/include/wasm.h", "crates/c-api/include/"
    lib.install shared_library("target/release/libwasmtime")
    include.install "crates/c-api/wasm-c-api/include/wasm.h"
    include.install Dir["crates/c-api/include/*"]
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")

    (testpath/"hello.wat").write <<~EOS
      (module
        (func $hello (import "" "hello"))
        (func (export "run") (call $hello))
      )
    EOS
    (testpath/"hello.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <wasm.h>
      #include <wasmtime.h>

      static void exit_with_error(const char *message, wasmtime_error_t *error, wasm_trap_t *trap);

      static wasm_trap_t* hello_callback(
          void *env,
          wasmtime_caller_t *caller,
          const wasmtime_val_t *args,
          size_t nargs,
          wasmtime_val_t *results,
          size_t nresults
      ) {
        printf("Calling back...\\n");
        printf("> Hello World!\\n");
        return NULL;
      }

      int main() {
        int ret = 0;
        // Set up our compilation context. Note that we could also work with a
        // `wasm_config_t` here to configure what feature are enabled and various
        // compilation settings.
        printf("Initializing...\\n");
        wasm_engine_t *engine = wasm_engine_new();
        assert(engine != NULL);

        // With an engine we can create a *store* which is a long-lived group of wasm
        // modules. Note that we allocate some custom data here to live in the store,
        // but here we skip that and specify NULL.
        wasmtime_store_t *store = wasmtime_store_new(engine, NULL, NULL);
        assert(store != NULL);
        wasmtime_context_t *context = wasmtime_store_context(store);

        // Read our input file, which in this case is a wasm text file.
        FILE* file = fopen("./hello.wat", "r");
        assert(file != NULL);
        fseek(file, 0L, SEEK_END);
        size_t file_size = ftell(file);
        fseek(file, 0L, SEEK_SET);
        wasm_byte_vec_t wat;
        wasm_byte_vec_new_uninitialized(&wat, file_size);
        assert(fread(wat.data, file_size, 1, file) == 1);
        fclose(file);

        // Parse the wat into the binary wasm format
        wasm_byte_vec_t wasm;
        wasmtime_error_t *error = wasmtime_wat2wasm(wat.data, wat.size, &wasm);
        if (error != NULL)
          exit_with_error("failed to parse wat", error, NULL);
        wasm_byte_vec_delete(&wat);

        // Now that we've got our binary webassembly we can compile our module.
        printf("Compiling module...\\n");
        wasmtime_module_t *module = NULL;
        error = wasmtime_module_new(engine, (uint8_t*) wasm.data, wasm.size, &module);
        wasm_byte_vec_delete(&wasm);
        if (error != NULL)
          exit_with_error("failed to compile module", error, NULL);

        // Next up we need to create the function that the wasm module imports. Here
        // we'll be hooking up a thunk function to the `hello_callback` native
        // function above. Note that we can assign custom data, but we just use NULL
        // for now).
        printf("Creating callback...\\n");
        wasm_functype_t *hello_ty = wasm_functype_new_0_0();
        wasmtime_func_t hello;
        wasmtime_func_new(context, hello_ty, hello_callback, NULL, NULL, &hello);

        // With our callback function we can now instantiate the compiled module,
        // giving us an instance we can then execute exports from. Note that
        // instantiation can trap due to execution of the `start` function, so we need
        // to handle that here too.
        printf("Instantiating module...\\n");
        wasm_trap_t *trap = NULL;
        wasmtime_instance_t instance;
        wasmtime_extern_t import;
        import.kind = WASMTIME_EXTERN_FUNC;
        import.of.func = hello;
        error = wasmtime_instance_new(context, module, &import, 1, &instance, &trap);
        if (error != NULL || trap != NULL)
          exit_with_error("failed to instantiate", error, trap);

        // Lookup our `run` export function
        printf("Extracting export...\\n");
        wasmtime_extern_t run;
        bool ok = wasmtime_instance_export_get(context, &instance, "run", 3, &run);
        assert(ok);
        assert(run.kind == WASMTIME_EXTERN_FUNC);

        // And call it!
        printf("Calling export...\\n");
        error = wasmtime_func_call(context, &run.of.func, NULL, 0, NULL, 0, &trap);
        if (error != NULL || trap != NULL)
          exit_with_error("failed to call function", error, trap);

        // Clean up after ourselves at this point
        printf("All finished!\\n");
        ret = 0;

        wasmtime_module_delete(module);
        wasmtime_store_delete(store);
        wasm_engine_delete(engine);
        return ret;
      }

      static void exit_with_error(const char *message, wasmtime_error_t *error, wasm_trap_t *trap) {
        fprintf(stderr, "error: %s\\n", message);
        wasm_byte_vec_t error_message;
        if (error != NULL) {
          wasmtime_error_message(error, &error_message);
          wasmtime_error_delete(error);
        } else {
          wasm_trap_message(trap, &error_message);
          wasm_trap_delete(trap);
        }
        fprintf(stderr, "%.*s\\n", (int) error_message.size, error_message.data);
        wasm_byte_vec_delete(&error_message);
        exit(1);
      }
    EOS
    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-lwasmtime", "-o", "hello"
    expected="Initializing...
Compiling module...
Creating callback...
Instantiating module...
Extracting export...
Calling export...
Calling back...
> Hello World!
All finished!"
    assert_equal expected, shell_output("./hello").chomp
  end
end
