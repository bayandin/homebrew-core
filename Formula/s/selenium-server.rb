class SeleniumServer < Formula
  desc "Browser automation for testing purposes"
  homepage "https://www.selenium.dev/"
  url "https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.12.0/selenium-server-4.12.0.jar"
  sha256 "101ba154c36d433437d688d3e79f4b21362bcc7d1ebc94f8b879badadb33234c"
  license "Apache-2.0"

  livecheck do
    url "https://www.selenium.dev/downloads/"
    regex(/href=.*?selenium-server[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f55f89007f4d810886797ee2694668b4c948311d82d6417fed9ea7171be2c1a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f55f89007f4d810886797ee2694668b4c948311d82d6417fed9ea7171be2c1a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f55f89007f4d810886797ee2694668b4c948311d82d6417fed9ea7171be2c1a7"
    sha256 cellar: :any_skip_relocation, ventura:        "f55f89007f4d810886797ee2694668b4c948311d82d6417fed9ea7171be2c1a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f55f89007f4d810886797ee2694668b4c948311d82d6417fed9ea7171be2c1a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f55f89007f4d810886797ee2694668b4c948311d82d6417fed9ea7171be2c1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47ec3d78127b08b3706f184aab9d4e254222820d1364509923702aab6c1f003"
  end

  depends_on "openjdk"

  def install
    libexec.install "selenium-server-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-#{version}.jar", "selenium-server"
  end

  service do
    run [opt_bin/"selenium-server", "standalone", "--port", "4444"]
    keep_alive false
    log_path var/"log/selenium-output.log"
    error_log_path var/"log/selenium-error.log"
  end

  test do
    port = free_port
    fork { exec "#{bin}/selenium-server standalone --selenium-manager true --port #{port}" }

    parsed_output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--silent", "localhost:#{port}/status")
      next unless $CHILD_STATUS.exitstatus.zero?

      parsed_output = JSON.parse(output)
      break if parsed_output["value"]["ready"]
    end

    assert !parsed_output.nil?
    assert parsed_output["value"]["ready"]
    assert_match version.to_s, parsed_output["value"]["nodes"].first["version"]
  end
end
