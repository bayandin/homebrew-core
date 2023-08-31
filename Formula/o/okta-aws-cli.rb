class OktaAwsCli < Formula
  desc "Okta federated identity for AWS CLI"
  homepage "https://github.com/okta/okta-aws-cli"
  url "https://github.com/okta/okta-aws-cli/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "f617b105e885fc8dc53accd7f3f8a2c3165b28b52abfbe7151e8353ad7eb427b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e48cb6a1855355c8e37d9a63a8230c8e8b917456a8fb97349a14c34cb7a27337"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3147e8617511571329c7ca44ccf8ca25f290670b61d5346667f93a9f7e8a630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c30e2e80b3f9aa9cde5f9b788212f967d3373f18abbefb2545b80af79078aaee"
    sha256 cellar: :any_skip_relocation, ventura:        "1b1c05c54cf71124ecdffc1684316381d21ee183048b53a7b7f0c56c9bdab965"
    sha256 cellar: :any_skip_relocation, monterey:       "c534a06d7f448f5f3668347df9f2e6f559014ac5a3fe94a9ee48c19d096dc490"
    sha256 cellar: :any_skip_relocation, big_sur:        "197067921d6abecec3c1f39e73de5fbf6d1e7d50a3a6fd6775ceef8fe79c9ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "745dc6d51dfa0ec0c7afcc491773a70a13bf411648851710b3f30c163b97c1ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/okta-aws-cli"
  end

  test do
    str_help = shell_output("#{bin}/okta-aws-cli --help")
    assert_match "Usage:", str_help
    assert_match "Flags:", str_help
    str_error = shell_output("#{bin}/okta-aws-cli -o example.org -c homebrew-test 2>&1", 1)
    assert_match 'Error: authorize received API response "404 Not Found"', str_error
  end
end
