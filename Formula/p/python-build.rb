class PythonBuild < Formula
  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/de/1c/fb62f81952f0e74c3fbf411261d1adbdd2d615c89a24b42d0fe44eb4bcf3/build-0.10.0.tar.gz"
  sha256 "d5b71264afdb5951d6704482aac78de887c80691c52b88a9ad195983ca2c9269"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d83d48e235c2f0df712103938c6f76c1dcaa7a840dca73109ff0842de90f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f4686a7cc93dd8254b16196da4b5314cc9819fd53e87b253d08dbdc41af2d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adbdf3df6cae13f89f8a5e0e22f24b0deafb62b9779dc32cbe3d3c4ab8ccec1a"
    sha256 cellar: :any_skip_relocation, ventura:        "6b30dc352f6573edaff4fffdd1f4153c5fb41f59a585d36ce685a4cacb641ac6"
    sha256 cellar: :any_skip_relocation, monterey:       "57686ab4d99f61ca65b345a41a00e24c4b619011e341a0d779e744f9c963fe28"
    sha256 cellar: :any_skip_relocation, big_sur:        "88a8a7d3a15a7fd5dcae318b3e15c9e58bde70cbfd6c9f95e2eb6b6eab83f67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d0881beff7e8b537ca1d3b1cbe63fcbf334234809cbc6ffb92d1afc19cbc82"
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
