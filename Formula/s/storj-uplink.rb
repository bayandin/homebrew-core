class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.86.1.tar.gz"
  sha256 "875e99ef2bc1aa61ead18645166cea366ba458e69f6003873e21961e11b997db"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e8f11ce089f05740077bbbd6d56f51776db38b6508e3fc82c096bb85bda138b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8f11ce089f05740077bbbd6d56f51776db38b6508e3fc82c096bb85bda138b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8f11ce089f05740077bbbd6d56f51776db38b6508e3fc82c096bb85bda138b"
    sha256 cellar: :any_skip_relocation, ventura:        "06d3006a2acc30b6623ec81847024c1fcec2602d9ab33e1b0368f32f8fd00709"
    sha256 cellar: :any_skip_relocation, monterey:       "06d3006a2acc30b6623ec81847024c1fcec2602d9ab33e1b0368f32f8fd00709"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d3006a2acc30b6623ec81847024c1fcec2602d9ab33e1b0368f32f8fd00709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acab1e6ab5fd5d6ac1c5cd5313fa7e1b938abc6e5b0dc9e930cb1992169eb89a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
