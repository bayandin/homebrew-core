class Zinit < Formula
  desc "Flexible and fast Zsh plugin manager"
  homepage "https://zdharma-continuum.github.io/zinit/wiki/"
  url "https://github.com/zdharma-continuum/zinit/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "ffa05360a150ef4745439d784338e5b17984851b86df4da125028db3a12b53b2"
  license "MIT"
  head "https://github.com/zdharma-continuum/zinit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2cce9233bb88996630f5f70908312fd63cb099bbf203c937cb0edbc35a5486b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2cce9233bb88996630f5f70908312fd63cb099bbf203c937cb0edbc35a5486b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2cce9233bb88996630f5f70908312fd63cb099bbf203c937cb0edbc35a5486b"
    sha256 cellar: :any_skip_relocation, ventura:        "c295baab06101206bb58abcb958adfa70fc70c063ed9a3c5ae35569558bc800f"
    sha256 cellar: :any_skip_relocation, monterey:       "c295baab06101206bb58abcb958adfa70fc70c063ed9a3c5ae35569558bc800f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c295baab06101206bb58abcb958adfa70fc70c063ed9a3c5ae35569558bc800f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2cce9233bb88996630f5f70908312fd63cb099bbf203c937cb0edbc35a5486b"
  end

  uses_from_macos "zsh"

  def install
    prefix.install Dir["*"]
    man1.install_symlink prefix/"doc/zinit.1"
  end

  def caveats
    <<~EOS
      To activate zinit, add the following to your ~/.zshrc:
        source #{opt_prefix}/zinit.zsh
    EOS
  end

  test do
    system "zsh", "-c", "source #{opt_prefix}/zinit.zsh && zinit load zsh-users/zsh-autosuggestions"
  end
end
