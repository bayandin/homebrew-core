class MesonPython < Formula
  desc "Meson PEP 517 Python build backend"
  homepage "https://meson-python.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ed/77/786ac8dcc8bc39a927527ba68a016bf9bd8f7ffe5c3622597ad16cd218af/meson_python-0.13.2.tar.gz"
  sha256 "80bc9de898acd36eb4b945afaaf7a2b4ca00189c51870d535e329761910cf8ea"
  license "MIT"

  depends_on "python-flit-core" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]
  depends_on "meson"
  depends_on "python-packaging"

  resource "pyproject-metadata" do
    url "https://files.pythonhosted.org/packages/38/af/b0e6a9eba989870fd26e10889446d1bec2e6d5be0a1bae2dc4dcda9ce199/pyproject-metadata-0.7.1.tar.gz"
    sha256 "0a94f18b108b9b21f3a26a3d541f056c34edcb17dc872a144a15618fed7aef67"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/site_packages
      python_exe = python.opt_libexec/"bin/python"

      resources.each do |r|
        r.stage do
          system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), Pathname.pwd
        end
      end

      system python_exe, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), "."
      (prefix/site_packages/"homebrew-deps.pth").write libexec/"vendor"/site_packages
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import mesonpy"
    end
  end
end
