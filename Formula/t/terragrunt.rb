class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.50.12.tar.gz"
  sha256 "3e3b65da88bcdbbe59834feccd666c8b3bcd4995e02c0645ca0970cffc545df2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04c1669a6eda1d9b64e03e4cc86a7a9a0699843a0767a9065395a81a654f827f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f1c92e135aaa8ad846a6bbfd23d5ef02b51d6b137ab68732541e2e87f8a7010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e23af61d9c02cd5d1b6d33d08c52fe58d6e64b8c0d375f95b4517c2d92b22693"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a40b515c1c867f74dbdd050231b947598358362dd5717f47adfcb12419342f"
    sha256 cellar: :any_skip_relocation, monterey:       "d37f221337be705d54afb6053942a86f06be031ad65b19ae22edaee289508eb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d67af3d4b64d282c6a2b72af0b702c1978ac404f1507b94c06ee87a5abe39044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619566a6ae0ce39169d9fc018cf0c20e4a94d5bbcbe51ea9d951926a6fa275b0"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
