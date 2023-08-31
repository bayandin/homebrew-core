class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.72.0-src.tar.gz"
    sha256 "ea9d61bbb51d76b6ea681156f69f0e0596b59722f04414b01c6e100b4b5be3a1"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.73.1",
          revision: "26bba48309d080ef3a3a00053f4e1dc879ef1de9"
    end

    # Fix for a compiler issue that may cause some builds to spin forever.
    # Remove on 1.73.0 release.
    # https://github.com/rust-lang/rust/pull/114948
    # https://github.com/rust-lang/rust/issues/115297
    # https://github.com/kpcyrd/sh4d0wup/issues/12
    patch do
      url "https://github.com/rust-lang/rust/commit/0f7f6b70617fbcda9f73755fa9b560bfb0a588eb.patch?full_index=1"
      sha256 "549f446612bef10a1a06a967f61655b59c1b6895d762d764ca89caf65c114fe9"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ebb7606e866133436ba0f6914746dd08ba07551a83887ac475540d705cc45d00"
    sha256 cellar: :any,                 arm64_monterey: "14c396c71bfc85ec4dceb235cc4142b4484c31736b99bf5ee5cc2be9f3d548cd"
    sha256 cellar: :any,                 arm64_big_sur:  "c2cf1974f723423d73588c4bd2d3ffe1d27e88c3e78506aa63da4ceb06b15cdf"
    sha256 cellar: :any,                 ventura:        "cf17622b469fd267981d97613d204196ec3725e54d25561a4e13df3ec9543426"
    sha256 cellar: :any,                 monterey:       "639a24c8f7460ba1c18488505605b05f172879e2b972045cdb38b8dfd809edbe"
    sha256 cellar: :any,                 big_sur:        "e204be3861c7f7df3f9ae0d56ffb1e41f0c865157784eb25933d2510ad0fa5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab9ba5c6d96bf35e29d7d95756f02c0e29a661e3907b4d08a0e85a6996b4686"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "rust-analyzer", because: "both install `rust-analyzer` binary"
  conflicts_with "rustfmt", because: "both install `cargo-fmt` and `rustfmt` binaries"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-aarch64-apple-darwin.tar.xz"
        sha256 "7637bc54d15cec656d7abb32417316546c7a784eded8677753b5dad7f05b5b09"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-x86_64-apple-darwin.tar.xz"
        sha256 "d83fe33cabf20394168f056ead44d243bd37dc96165d87867ea5114cfb52e739"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "13e8ff23d6af976a45f3ab451bf698e318a8d1823d588ff8a989555096f894a8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "fe6fb520f59966300ee661d18b37c36cb3e614877c4c01dfedf987b8a9c577e9"
      end
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    cargo_src_path = buildpath/"src/tools/cargo"
    cargo_src_path.rmtree
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    # rustfmt and rust-analyzer are available in their own formulae.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{Formula["llvm"].opt_prefix}
      --enable-llvm-link-shared
      --enable-vendor
      --disable-cargo-native-static
      --set=rust.jemalloc
      --release-description=#{tap.user}
    ]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"rustlib/src/rust").install "library"
    rm_f [
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ]
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }
  end
end
