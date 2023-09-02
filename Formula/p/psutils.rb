class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/05/90/cd6c0ec88ba12e511d7d73db720c23f41f020f88f68d914667d43a68fd70/pspdfutils-3.2.0.tar.gz"
  sha256 "921caf6207670574f15d03855a715f0b597420135cefe3455aec5342350f06ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcc24c8f597ddaf4bc08b74612132161808c5c743334c4e4a715ceaea385d24c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc9556d3a42d4e3f61616464559ee950a141e8f4356d61d562fd4617112ecc26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0f89877c10235876f735416027adf1004c9124ebdb3a7816fff2e6c9150666c"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6bc21641cd9302febd11374aca51a9005117672503ba8148d48a447dac964f"
    sha256 cellar: :any_skip_relocation, monterey:       "de338343cea2ea6b2495550095def7e2d918f3f39a82e5c661f18d715e3d255d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae5e7f777cfdd4d4b8e7c8ee58d39fbb0a475c89e774cd66bfdc3343b1212b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76b79604ef7aea41fd092fb0342fc983794fab01467d1adc3c8170f725d4111"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/8c/5f/07d3462b0ccf11e789e21ee4af2c3e817297ea3f8328e202a547cb0cf253/pypdf-3.15.4.tar.gz"
    sha256 "a2780ed01dc4da23ac1542209f58fd3d951d8dd37c3c0309d123cd2f2679fb03"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end
