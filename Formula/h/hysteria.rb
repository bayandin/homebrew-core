class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.0.0.tar.gz"
  sha256 "06f86cf466cbe08e7aaea68914263780ed4474cd73df9a591676779535d330d5"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "590b5440ea6348e190e579bf6d92e0030c88c1e41d8924d688184dac998add0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "590b5440ea6348e190e579bf6d92e0030c88c1e41d8924d688184dac998add0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "590b5440ea6348e190e579bf6d92e0030c88c1e41d8924d688184dac998add0b"
    sha256 cellar: :any_skip_relocation, ventura:        "2e4a2e773aafe7bc57c15ac6f2aab7f78791ea2095a0dafa8bc3d12055f5588a"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4a2e773aafe7bc57c15ac6f2aab7f78791ea2095a0dafa8bc3d12055f5588a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e4a2e773aafe7bc57c15ac6f2aab7f78791ea2095a0dafa8bc3d12055f5588a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8635bc4da9255afb22cb697da0103d0c37a0b2de97f0bda58d3297f158186f6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/apernet/hysteria/app/cmd.appVersion=v#{version}
      -X github.com/apernet/hysteria/app/cmd.appDate=#{time.iso8601}
      -X github.com/apernet/hysteria/app/cmd.appType=release
      -X github.com/apernet/hysteria/app/cmd.appCommit=#{tap.user}
      -X github.com/apernet/hysteria/app/cmd.appPlatform=#{OS.kernel_name.downcase}
      -X github.com/apernet/hysteria/app/cmd.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~EOS
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    EOS
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
