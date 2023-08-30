class Udp2rawMultiplatform < Formula
  desc "Multi-platform(cross-platform) version of udp2raw-tunnel client"
  homepage "https://github.com/wangyu-/udp2raw-multiplatform"
  url "https://github.com/wangyu-/udp2raw-multiplatform/archive/refs/tags/20230206.0.tar.gz"
  sha256 "a4c2aece9e302a7895319efe940e5693522bafe9ae35b3f8088f091b35599e8a"
  license "MIT"

  depends_on "libnet"
  uses_from_macos "libpcap"

  def install
    ENV["OPT"] = Utils.safe_popen_read("libnet-config", "--cflags")

    if OS.linux?
      system "make", "linux"
    elsif OS.mac?
      system "make", "mac"
    end

    bin.install "udp2raw_mp"
    etc.install "example.conf" => "udp2raw_client.conf"
  end

  service do
    run [opt_bin/"udp2raw_mp", "--conf-file", etc/"udp2raw_client.conf"]
    keep_alive true
    require_root true
    log_path var/"log/udp2raw.log"
    error_log_path var/"log/udp2raw.log"
  end

  test do
    assert_match(/.+SOCK_RAW allocation failed: Operation not permitted/,
      shell_output(
        "#{bin}/udp2raw_mp -c -r 127.0.0.1:#{free_port} -l 127.0.0.1:#{free_port} --log-level 1 --disable-color", 255
      ))
  end
end
