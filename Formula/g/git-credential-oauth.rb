class GitCredentialOauth < Formula
  desc "Git credential helper that authenticates in browser using OAuth"
  homepage "https://github.com/hickford/git-credential-oauth"
  url "https://github.com/hickford/git-credential-oauth/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f5656771f51fa9a2e947da11e426bd724992c3fb950f42800022646a16f9978c"
  license "Apache-2.0"
  head "https://github.com/hickford/git-credential-oauth.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30408de11b6182bf563d036ae36594bfef1dbcf2b1449d657e0d5c16e1df6843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30408de11b6182bf563d036ae36594bfef1dbcf2b1449d657e0d5c16e1df6843"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30408de11b6182bf563d036ae36594bfef1dbcf2b1449d657e0d5c16e1df6843"
    sha256 cellar: :any_skip_relocation, ventura:        "61f0b170ae5899580395fa70002ff315a54ecbcf4375053573f483793c5de55a"
    sha256 cellar: :any_skip_relocation, monterey:       "61f0b170ae5899580395fa70002ff315a54ecbcf4375053573f483793c5de55a"
    sha256 cellar: :any_skip_relocation, big_sur:        "61f0b170ae5899580395fa70002ff315a54ecbcf4375053573f483793c5de55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631cea37fd2ee0b72296b15f22193e41be5bea7b7bfeed931e7eb6573da825c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_empty shell_output("#{bin}/git-credential-oauth", 2)
  end
end
