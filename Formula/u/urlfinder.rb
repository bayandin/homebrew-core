class Urlfinder < Formula
  desc "Extracting URLs and subdomains from JS files on a website"
  homepage "https://github.com/pingc0y/URLFinder"
  url "https://github.com/pingc0y/URLFinder/archive/refs/tags/2023.9.2.tar.gz"
  sha256 "ffc5c2a92f3f43a2e135903a5a2d3ac2c3f7e21a9e4bcf0913f59687b1ccfdcc"
  license "MIT"
  head "https://github.com/pingc0y/URLFinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "063b533a9038c1cc32aeade4df541d2c99dad35f503bed97fc4f1ca423f53574"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f4f97b1db830288d3c45077e84f9499959e234cf5473de63f3deb817c566da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1e6e5975095223bdb42312f0f42c4aa9e8997ac52d144f36514e91c7b13ffec"
    sha256 cellar: :any_skip_relocation, ventura:        "3def9792a0212d09bf9bbfadf739d4e899a608a983e4af0b414202305ae26f47"
    sha256 cellar: :any_skip_relocation, monterey:       "71b2983b6be2e9a2ae237a26cee3ebba5c52c98178e344195f4cbb25d205bcaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef6bf2f39af660bb97152bfefef89391b66a0ea7cfab3c47f41be22c7c77599d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "211ca1d91233974c02ec2dfc849f1f80520cc068bb2567af72e52e20ebb4db40"
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
