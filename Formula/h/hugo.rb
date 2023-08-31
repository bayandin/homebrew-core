class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.118.1",
      revision: "0eb480aa1d06653803175e3fdfad5dbf5fc26f9b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2a79837d696899fa12b1d05cf654a0c357ccbbcfc88dfae27b925ad51a20642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a3e6563e231f5a2a78fa6e693d773c854b37ab49adeb8bf22f11833b8db7909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb8929d31f9731d081a1692e60b7044cc177cc3b5f7abdaee6fc1be430e48e9b"
    sha256 cellar: :any_skip_relocation, ventura:        "9c8cbaab6184581ea21026af8ff0ba1c1bd2bc36c66a3d5525df19561e94a454"
    sha256 cellar: :any_skip_relocation, monterey:       "078ecf79485c7c80f0df61c8dc7031b23f1ec508584f1a7a0648a0490c1cdd7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dcdd072d1a0d8e044ed939ab483ca3ad41281eab3f7f55001bede4b867f1f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e47c9c0074fe6093658d60841e391bd2ef313e0e751f0e5963d0b211064e9dd"
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
