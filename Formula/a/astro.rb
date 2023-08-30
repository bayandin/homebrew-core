class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "9bf6cf1ddb3000f5912b8cf3bc7f81d5e92defe0131da6a0a317e5ed8ecbe20b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e7800f118a66ae07f3e59581f9f0947a5fba8c191364079de63382719344b2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7800f118a66ae07f3e59581f9f0947a5fba8c191364079de63382719344b2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e7800f118a66ae07f3e59581f9f0947a5fba8c191364079de63382719344b2c"
    sha256 cellar: :any_skip_relocation, ventura:        "1c3a73326538b625fc5472df50ce050db70df399b8f2ee10934a9ed07f8a896b"
    sha256 cellar: :any_skip_relocation, monterey:       "1c3a73326538b625fc5472df50ce050db70df399b8f2ee10934a9ed07f8a896b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c3a73326538b625fc5472df50ce050db70df399b8f2ee10934a9ed07f8a896b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7648db68dea04cca02336a8cccf65eadf500dcacf15be7a65412a0876eaa160a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
