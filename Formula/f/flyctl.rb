class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.87",
      revision: "499c43286ab82c5ef5b56bff2823fadb387f78f3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8fc3dacf68e612539b46b0085b7574604537f5da34641aa73a35a545d060db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff8fc3dacf68e612539b46b0085b7574604537f5da34641aa73a35a545d060db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff8fc3dacf68e612539b46b0085b7574604537f5da34641aa73a35a545d060db"
    sha256 cellar: :any_skip_relocation, ventura:        "d81ccaa9d419ded5b191c1b392ad9fe5678c3ca223ee7a37754b14d65e4c8ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "d81ccaa9d419ded5b191c1b392ad9fe5678c3ca223ee7a37754b14d65e4c8ad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d81ccaa9d419ded5b191c1b392ad9fe5678c3ca223ee7a37754b14d65e4c8ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14833e1646fc57e893e3597212fc99d488c73b34b3d131e3b6fd0e19b8e6a9af"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
