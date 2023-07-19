class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "32ba647a9715efe2699acd3d011e9f113891be02ac011d314b955a9beea723a2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae00013ef65a9ed015c968b8ee9daff7e6147cc5a99c8cdac657ee92f4a8461d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3812711969be43a9a8a2636b5aa7a76fdf8f1a4b59301cf3224cf36e1ab3422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b44fb4f1512e6932dae71f77992458c47ef45d26efcfe2915c734b692385d19"
    sha256 cellar: :any_skip_relocation, ventura:        "f35c099a16fd131a423d5a181730d569332963687e9b9d052b1ccda54daa5569"
    sha256 cellar: :any_skip_relocation, monterey:       "95e6c58fe6e57aab6b4824e79eca7f1985cdd57c30e4d8dbb8bdc6c54b4c57c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1a7a2e82215d39777dd959159ae96d130265f8186e64b15254912b1553e4181"
    sha256 cellar: :any_skip_relocation, catalina:       "1a2d1361705ac673b214c228679a84ede04c843448eb756ae71f5b1ab3e7db01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b770894376d5273adc2e8731db63e00a32ea93b05cad6ab94a401e7aa1a9ead"
  end

  depends_on "rustup-init" => :build
  depends_on "rust" => :test
  uses_from_macos "zlib"

  def install
    system "rustup-init", "--profile", "minimal", "-qy", "--no-modify-path", "--default-toolchain", "none"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    ENV["CFG_RELEASE_CHANNEL"] = "stable"
    system "cargo", "install", *std_cargo_args

    # Bundle the shared libraries used by the executables.
    # https://github.com/NixOS/nixpkgs/blob/6cee3b5893090b0f5f0a06b4cf42ca4e60e5d222/pkgs/development/compilers/rust/rustfmt.nix#L18-L27
    bundled_dylibs = %w[librustc_driver libstd]
    bundled_dylibs << "libLLVM" if OS.linux?
    bundled_dylibs.each do |libname|
      dylib = buildpath.glob(".brew_home/.rustup/toolchains/*/lib/#{shared_library("#{libname}-*")}")
      libexec.install dylib
    end

    # Fix up rpaths.
    bins_to_patch = [
      bin/"rustfmt",
      bin/"git-rustfmt",
    ]
    bins_to_patch << libexec.glob(shared_library("librustc_driver-*")).first if OS.linux?
    bins_to_patch.each do |bin|
      extra_rpath = rpath(source: bin.dirname, target: libexec)
      if OS.mac?
        MachO::Tools.add_rpath(bin, extra_rpath)
        MachO.codesign!(bin) if Hardware::CPU.arm?
      elsif OS.linux?
        patcher = bin.patchelf_patcher
        patcher.rpath = [*bin.rpaths, extra_rpath].join(":")
        patcher.save(patchelf_compatible: true)
      end
    end
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system bin/"rustfmt", "--check", "./src/main.rs"
    end

    # Make sure all the executables work after patching.
    bin.each_child { |exe| system exe, "--help" }
  end
end
