class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "c6b5ef36bab002dae1fda9857f4c2e424403e2ba02f9c86b6d65c56a679eab59"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2749007faacbfefb5c20c714d6493bfe543398c2ea6dc760ceaaa9c3e67f562d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb827b67b26043e0857a72c620729e12c0bd5f9f29260d83f7dce8856676a6b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "373a80ce9987c38192373bc64183cd01790314cce67a73e19e1660a5603ebf9a"
    sha256 cellar: :any_skip_relocation, ventura:        "fc13105aa1fcbbe87a76b7986ea34daf9562899ad7c0380bdb9757c25a30da0d"
    sha256 cellar: :any_skip_relocation, monterey:       "19fe25ad8b9c8a4c745a38571091a54a85102255f02247ff92a7a33a969e9162"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf729928435efc647180a5b1c17166be53bff564768f78a411520afc883f935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c292db679e90b1ae5dc2aa62692bd0c9329bfa157951e70017e9504bfb12e2"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
