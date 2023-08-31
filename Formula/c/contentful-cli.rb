require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.0.tgz"
  sha256 "88059fe2c2afa95a292f165df4f2dc8886d334a9944135034f66fde620c936b8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c7ccb28379da17ebb333162ed5cb4dc8d8d20adae2c292e105ee560adfb98b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c7ccb28379da17ebb333162ed5cb4dc8d8d20adae2c292e105ee560adfb98b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c7ccb28379da17ebb333162ed5cb4dc8d8d20adae2c292e105ee560adfb98b7"
    sha256 cellar: :any_skip_relocation, ventura:        "0a1895f6b231cc742c61db0d6b8ce556db7c5ddc5df8ca90efc9ea11d1e5f23e"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1895f6b231cc742c61db0d6b8ce556db7c5ddc5df8ca90efc9ea11d1e5f23e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a1895f6b231cc742c61db0d6b8ce556db7c5ddc5df8ca90efc9ea11d1e5f23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c7ccb28379da17ebb333162ed5cb4dc8d8d20adae2c292e105ee560adfb98b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
