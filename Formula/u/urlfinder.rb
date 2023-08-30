class Urlfinder < Formula
  desc "Extracting URLs and subdomains from JS files on a website"
  homepage "https://github.com/pingc0y/URLFinder"
  url "https://github.com/pingc0y/URLFinder/archive/refs/tags/2023.8.30.tar.gz"
  sha256 "a8a05f8bc9e4a1fe56b3920a213f12c60350004f85529280b45f90361d68a24b"
  license "MIT"
  head "https://github.com/pingc0y/URLFinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f0811a60f05f9e710aa850e29d7349c98c5a84cfb13e2ec526de4c2772580f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0811a60f05f9e710aa850e29d7349c98c5a84cfb13e2ec526de4c2772580f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f0811a60f05f9e710aa850e29d7349c98c5a84cfb13e2ec526de4c2772580f7"
    sha256 cellar: :any_skip_relocation, ventura:        "92b9eb4709bba949c8712cf2296d7293ebec619b8f29b657554b4780582d3bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "92b9eb4709bba949c8712cf2296d7293ebec619b8f29b657554b4780582d3bf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "92b9eb4709bba949c8712cf2296d7293ebec619b8f29b657554b4780582d3bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f19ac1ec01277bb2248c29d73b8101f0946580cbaa850948e00dce6fb2841d5a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Start 1 Spider...", shell_output("#{bin}/urlfinder -u https://example.com")
    assert_match version.to_s, shell_output("#{bin}/urlfinder version")
  end
end
