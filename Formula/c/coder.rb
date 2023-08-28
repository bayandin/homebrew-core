class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "d120365122fc047781c77090ab47f4ae6e675c1e69f6e03b500240deee2d60a2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4633bfba8d871f77230a9504a5d82157dca41ee110f5eddaeed73276cced669"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2a588961b03936840780b516534346c93a24d70553f7efe736f34c829c3236b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7974c279221874aa4ba85caa2332b7d056b1114513b76f12441ef233868a62e8"
    sha256 cellar: :any_skip_relocation, ventura:        "4acee70284a5a4b032e7aa0888fb86310039a5c8c1dc4b970bf4815c88c6f08e"
    sha256 cellar: :any_skip_relocation, monterey:       "6ebf714c86439c37b0d4da106d31e4e43de918daa46a1d0672c55dcdbbcacc10"
    sha256 cellar: :any_skip_relocation, big_sur:        "97789af65ad39ca0616c3debbbe7892c9aab94e6674a141f00e1651ebd9a98af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9123125e87a256d6177d50c8b2b392d3c198b1fdd323e2c658ab2c50bec72751"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
