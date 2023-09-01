class PythonBuild < Formula
  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/e8/27/f6b1c6d316ef655a10668984575c21feee9eda292bc1d718707566010ea0/build-1.0.0.tar.gz"
  sha256 "49a60f212df4d9925727c2118e1cbe3abf30b393eff7d0e7287d2170eb36844d"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90134ae48e4aa340e3df110a19fab26463d1f556fd6154243859d02eff59b76a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fe7214ad633c24ab6613e6934971947838c99bb75decdcd28bb1a648f2fb8aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "371b9da1b4b1ba74ef3cb158d55a3bf1fd0e11cffcac04f82fc24435cb1f1617"
    sha256 cellar: :any_skip_relocation, ventura:        "4ceb88b44b9154b9b48b0480d12459510cdf099016ec4b20e29d7655ceb6ad7e"
    sha256 cellar: :any_skip_relocation, monterey:       "b61c9c83b87e98978972713bb3c34eeaca0d655b3e29a2a65604f5ca9b271306"
    sha256 cellar: :any_skip_relocation, big_sur:        "63e6f32e4320fc9f1d47f965cf41ac3aeb8887506eedb390a2b66851d8bc7c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f26344bdbcc51b71d316e7312cf467e426251c6ba6d010ce87ca6d4154f857b6"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-packaging"
  depends_on "python-pyproject-hooks"
  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python3, "-c", "import build"

    stable.stage do
      system bin/"pyproject-build"
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end
