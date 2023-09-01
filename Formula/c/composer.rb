class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.6.0/composer.phar"
  sha256 "3b190c1cb72670fc033a4831e68c02068c0300616bde4d6ef4d1a183b7d33cc4"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26334a4d2c3eecdd33758a3c710594ad17a3840b8c03bbf7f287b0054f333729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26334a4d2c3eecdd33758a3c710594ad17a3840b8c03bbf7f287b0054f333729"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26334a4d2c3eecdd33758a3c710594ad17a3840b8c03bbf7f287b0054f333729"
    sha256 cellar: :any_skip_relocation, ventura:        "37006058236651ec38e9942b633ff9ff656d3a0effe04e75e656bafc36b672f1"
    sha256 cellar: :any_skip_relocation, monterey:       "37006058236651ec38e9942b633ff9ff656d3a0effe04e75e656bafc36b672f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "37006058236651ec38e9942b633ff9ff656d3a0effe04e75e656bafc36b672f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26334a4d2c3eecdd33758a3c710594ad17a3840b8c03bbf7f287b0054f333729"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~EOS
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    EOS

    (testpath/"src/HelloWorld/Greetings.php").write <<~EOS
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    EOS

    (testpath/"tests/test.php").write <<~EOS
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    EOS

    system "#{bin}/composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
