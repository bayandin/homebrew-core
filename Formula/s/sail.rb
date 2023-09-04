class Sail < Formula
  include Language::Python::Virtualenv

  desc "CLI toolkit to provision and deploy WordPress applications to DigitalOcean"
  homepage "https://sailed.io"
  url "https://files.pythonhosted.org/packages/bf/9b/a717ef852721fa827cfc04b291ab771816684e35819ca0f6e1860ee072a4/sailed.io-0.10.7.tar.gz"
  sha256 "f29ef45da60a4092587c81f2b4bd61eb5332cea12592f42b20b6553ec3b0dc12"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d968108fae75b9c00fefa842cbb65026f8b069c8ffa4d7b73157ebbe6508f890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eb6009674b2ae9d79b3fdcdf7be788d55b8c3640ce0a306a7e515eb5a91d473"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "526e87c49deb9e9ec79a43cb97fd03f77e79ca313ef891a64f63ac6ee22935a2"
    sha256 cellar: :any_skip_relocation, ventura:        "142bde502373558f6bbda78a10a280bf4b7a1b990a10476f302f0d6ba97e2425"
    sha256 cellar: :any_skip_relocation, monterey:       "0c989e825a1aebb6ca5207e26c5e0b4210ee2d6b370feadfebf00ec7ce0a560b"
    sha256 cellar: :any_skip_relocation, big_sur:        "408f032bd4c4160427ccbf02dd50a57bc0fdd2343ffbba0e7c653922336bc6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ebd015859b2435335047456c55baa315cb572b865c18d7ce874920f82906290"
  end

  depends_on "fabric"
  depends_on "pyinvoke"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/6e/92/62fdc2f6b468b870dd171ad21748ef0ec2bff1b258c25ce6db3545cccc90/jsonpickle-3.0.2.tar.gz"
    sha256 "e37abba4bfb3ca4a4647d28bb9f4706436f7b46c8a8333b4a718abafa8e46b37"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/9f/67/9442fd49ac0d234933c9c90cb2e2f072d9df021577547c09456dd4484ed4/tldextract-3.4.0.tar.gz"
    sha256 "78aef13ac1459d519b457a03f1f74c1bf1c2808122a6bcc0e6840f81ba55ad73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    site_packages = Language::Python.site_packages(python3)
    %w[fabric pyinvoke].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end

    venv.pip_install_and_link buildpath
  end

  test do
    xy = Language::Python.major_minor_version "#{libexec}/bin/python"
    unittest = "#{libexec}/bin/python -m unittest discover " \
               "#{libexec}/lib/python#{xy}/site-packages/sail/tests 2>&1"

    assert_match(version.to_s, shell_output("#{bin}/sail --version"))
    assert_match("Could not parse .sail/config.json", shell_output("#{bin}/sail deploy 2>&1", 1))
    assert_match("OK", shell_output(unittest))
  end
end
