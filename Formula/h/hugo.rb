class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.118.0",
      revision: "28b640a220f31e17ddd2548a111b722baa22c525"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87f4683306371714c905e9ad817057b6c5911104f117aaf7e3d22cb434ba0f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35e62c7b34ffb7a7ee613921cf43350629fa126b0d38cb2b636903260503edcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ce0957c3435ca1bb5601adb14da22285ae8f1a8d29d11dfcfea89ac42974361"
    sha256 cellar: :any_skip_relocation, ventura:        "018da41a96f7a165fef5892b90d3b115551da9fde31252e97e8b0bb49ba61f03"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b9355237b1de910d6310444b1625834771049b817fcc3fa24f28e42d449d50"
    sha256 cellar: :any_skip_relocation, big_sur:        "41e8ac2e4d64a7aecef3b75a120b0dee86faae0e93973bfc47dfeb3bd099daeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c06727b9235b7070d4fa0ae6834282fd03ef28785a8bfa4e4cfec9fe5b052e9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
