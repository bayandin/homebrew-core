class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "61e119a3d9b8f8083b7765236bc52afe779a0c2ae8c3aebc9e52d36560733772"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c17b89c8d6370b428bbaf59587571435fc92c1e072a2ec35e5fb6f9b835fb78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fad881f3e7cdf8f2549bebfe777b2bd597b1c750742b5b1cf9e3316f6e877e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1723c15bb0200f4d39103795bd8531657071c64dfcad8985d96652f598f9ff8"
    sha256 cellar: :any_skip_relocation, ventura:        "2f55451a0e468601a14652ff3c4ba866ca55b447d836db69c5205fcaf5edaeff"
    sha256 cellar: :any_skip_relocation, monterey:       "bf9363baa0662d5e687cc0439a6c458a1191a9c587374a464976a3ea3b50b526"
    sha256 cellar: :any_skip_relocation, big_sur:        "63753311d08885ec09f71b47d6442a7eec7405d4123376e9d51b228c256419a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75672cf4f41c9fa3814a499065b6aed41a2a7001fbd9a194586063c229f25bcd"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-typing-extensions" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "rust"

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "setuptools-rust" do
    url "https://files.pythonhosted.org/packages/90/f1/70b31cacce03bf21fa645d359d6303fb5590c1a02c41c7e2df1c480826b4/setuptools-rust-1.7.0.tar.gz"
    sha256 "c7100999948235a38ae7e555fe199aa66c253dc384b125f5d85473bf81eae3a3"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def pythons
    deps.map(&:to_formula)
        .filter { |f| f.name.start_with?("python@") }
        .sort_by(&:version)
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python)
      resources.each do |r|
        r.stage do
          system python, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
        end
      end

      system python, "-m", "pip", "install", *std_pip_args, "."
    end

    # overwrite the minimal binary that pip installed
    system "cargo", "install", *std_cargo_args, "--force"
    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    pythons.each do |python|
      system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
      system python, "-m", "pip", "uninstall", "-y", "hello_world"
    end
  end
end
