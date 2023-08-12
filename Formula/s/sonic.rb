class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "54c4bf768808ae1b5526d3c557759f5f0fd31aac453aba71638b498fc9015170"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba4c2939b999ae73c46cceecb21e25f67f2c0107d8fc53b4ffbe5337299a66c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a2d41df229febf3a5fc32b1af2c78657810e12ef94ca9522a318b590365bf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42ec66f78a25bd41bfb235b6684aa4f17c7360a5cdc2fdff6206b9be0c0b62e0"
    sha256 cellar: :any_skip_relocation, ventura:        "cdc64f315ef84bee7373ce6d79bb3d556ab9f834c2a1dd69a096bcb5bef9cdbb"
    sha256 cellar: :any_skip_relocation, monterey:       "00d1c7357fcb1261433e54856267d7c653701b8d154e4951cd16ba70fe66c3c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "322caf905b32c77a887ac05a5c9d78d1116e3af9701ecc27652c813d86c9f1a6"
    sha256 cellar: :any_skip_relocation, catalina:       "9396cb130cd9db11186a103e19371ff06d1e6e72ef784f5b9f94415ef29dfef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a26ea1c3ca5619ac1f72d37526b47862512c136bc0e56b24c5b023b72c1d42"
  end

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # https://github.com/rust-lang/rust-bindgen/issues/2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
  # updated to 0.62.0 or newer. There is a check in the `install` method.
  depends_on "llvm@15" => :build
  depends_on "rust" => :build

  uses_from_macos "netcat" => :test

  def install
    bindgen_version = Version.new(
      (buildpath/"Cargo.lock").read
                              .match(/name = "bindgen"\nversion = "(.*)"/)[1],
    )
    if bindgen_version >= "0.62.0"
      odie "`bindgen` crate is updated to 0.62.0 or newer! Please remove " \
           'this check and try switching to `uses_from_macos "llvm" => :build`.'
    end

    system "cargo", "install", *std_cargo_args
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  service do
    run [opt_bin/"sonic", "-c", etc/"sonic.cfg"]
    keep_alive true
    working_dir var
    log_path var/"log/sonic.log"
    error_log_path var/"log/sonic.log"
  end

  test do
    port = free_port

    cp etc/"sonic.cfg", testpath/"config.cfg"
    inreplace "config.cfg", "[::1]:1491", "0.0.0.0:#{port}"
    inreplace "config.cfg", "#{var}/sonic", "."

    fork { exec bin/"sonic" }
    sleep 10
    system "nc", "-z", "localhost", port
  end
end
