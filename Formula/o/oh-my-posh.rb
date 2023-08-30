class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v18.6.0.tar.gz"
  sha256 "b7042f70e7384aea62765e5bc1926a9c7c215f4f6225cc1ce710ae6773eab4c7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0584a2d8525c99ff3fb9d1354760b062c26b168e6130e7fd5cad0f80b5dfdb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beeb28bc448c484422189cf175494b474eea4a62a9c835647138222d222c1d02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40e88667371ea64012f90e375d3a1727aeaf14322eb18c7cbc71f4d4703f7165"
    sha256 cellar: :any_skip_relocation, ventura:        "632ec30a037f92f09df0d09a1775b11f13cb27727b6eb118648284a6869958b2"
    sha256 cellar: :any_skip_relocation, monterey:       "74144e5fdae50e5b1bb7fc195de6c2e24dd2ed59b8957896c569ae131b815329"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c38ee5c67d978d449de7dc21c166f7c643fa8de0527e1f9ea5349832f9cadfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5107034ee7637204ad01dd5d35e662acd938fcb71dcce80a709f729a60c8e745"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
