class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/d8/59/bb9e052fba37972e4b27db74d0bc770bade501d48336dec3c89fe57e9513/cruft-2.15.0.tar.gz"
  sha256 "9802af66037418655e7e4b6f30b531591e0761939b3ff5dd45d27c3a3f588abe"
  license "MIT"
  revision 2
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b90d47f000634dda647489eca780b87bc487e057f2a413d19c6cdf27c21ea271"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96cfc3d16aabe0991fd99028ad4a3c65a57d89e7d451931eda4b1ee83220b94f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9b5e2e06bb8a076497e284ec53f149822542e95e4aa438bca5226179fe816fa"
    sha256 cellar: :any_skip_relocation, ventura:        "48791559120325941ecbf5ccbaff42a03dcd0cdc713959e7a8e394c052d4e530"
    sha256 cellar: :any_skip_relocation, monterey:       "5faa4594ae96a39f74349e5bed4ef73aaaa99312977d714988be979d7bab91b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1eb781e6f665efc4d1d3b9de9cc27b8dbbc38c163deac1657b4457db295edfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe10268bdb502ccaaf1998781fe165fcd7e825956b453f249a01b1e617c2ef5"
  end

  depends_on "cookiecutter"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/8d/1e/33389155dfe8cebbaa0c5b5ed0d3bd82c5e70064be00b2b3ee938da8b5d2/GitPython-3.1.33.tar.gz"
    sha256 "13aaa3dff88a23afec2d00eb3da3f2e040e2282e41de484c5791669b31146084"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5b/49/39f10d0f75886439ab3dac889f14f8ad511982a754e382c9b6ca895b29e9/typer-0.9.0.tar.gz"
    sha256 "50922fd79aea2f4751a8e0408ff10d2662bd0c8bbfa84755a699f3bada2978b2"
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
