class PhpCsFixer < Formula
  desc "Tool to automatically fix PHP coding standards issues"
  homepage "https://cs.symfony.com/"
  url "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v3.25.1/php-cs-fixer.phar"
  sha256 "cb0d89a37603d64360d97e42401093a4da15c220d633bfd1c4a1118e3e35e312"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d59f5628d48bf8021ee38965bb13b5923a50dd0ef00a34e7a85b928a581bd2c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d59f5628d48bf8021ee38965bb13b5923a50dd0ef00a34e7a85b928a581bd2c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d59f5628d48bf8021ee38965bb13b5923a50dd0ef00a34e7a85b928a581bd2c8"
    sha256 cellar: :any_skip_relocation, ventura:        "d59f5628d48bf8021ee38965bb13b5923a50dd0ef00a34e7a85b928a581bd2c8"
    sha256 cellar: :any_skip_relocation, monterey:       "d59f5628d48bf8021ee38965bb13b5923a50dd0ef00a34e7a85b928a581bd2c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d59f5628d48bf8021ee38965bb13b5923a50dd0ef00a34e7a85b928a581bd2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "224fdad117c0a07a4c670e0cfeb5c0947457daadd6f4a8cd9d4bffef071a1b47"
  end

  depends_on "php"

  def install
    libexec.install "php-cs-fixer.phar"

    (bin/"php-cs-fixer").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/php-cs-fixer.phar';
    EOS
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php $this->foo(   'homebrew rox'   );
    EOS
    (testpath/"correct_test.php").write <<~EOS
      <?php

      $this->foo('homebrew rox');
    EOS

    system bin/"php-cs-fixer", "fix", "test.php"
    assert compare_file("test.php", "correct_test.php")
  end
end
