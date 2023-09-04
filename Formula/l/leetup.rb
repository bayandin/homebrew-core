class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/v1.2.2.tar.gz"
  sha256 "b6df1d5ccef8baeaaefd0c67000b0898beb3f564d55061ac396a8e40e7cd3404"
  license "MIT"
  head "https://github.com/dragfire/leetup.git", branch: "master"

  # This repository also contains tags with a trailing letter (e.g., `0.1.5-d`)
  # but it's unclear whether these are stable. If this situation clears up in
  # the future, we may need to modify this to use a regex that also captures
  # the trailing text (i.e., `/^v?(\d+(?:\.\d+)+(?:[._-][a-z])?)$/i`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c173d42fa3421aa14d4de8d0a98a9af0be2a08bd25fe047f49b68f07c52030f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273fc93873da0cc4dbc25f18d51519f09e27ff0a0392c439c4ba4bbcdfb582ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52b502cbea4af8ff33bf06ec9d298c58a2ca2fffc3bfb59c7d4fbb551b28d21c"
    sha256 cellar: :any_skip_relocation, ventura:        "e213a38572afd720990793abdcdd7b90634f1a8ab568c59a5abbe908f9cec9a4"
    sha256 cellar: :any_skip_relocation, monterey:       "d2568cdfb47eb02b78cde01d5e5b97cdc3c965af6b117732ad31eff33c29d439"
    sha256 cellar: :any_skip_relocation, big_sur:        "6920f2e7185df2318fcd62a1e988ca4e2137013a7cbe18a22954b4c642e94f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01d878dab60eadcea639c87c46912b5d6444ded11005bae2d812051de5713d7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Easy", shell_output("#{bin}/leetup list 'Two Sum'")
  end
end
