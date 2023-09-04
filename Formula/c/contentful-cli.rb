require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.2.tgz"
  sha256 "325182dd331493356e1ad563ee251d62df3cdbabbe48d5e7c20e3d39b3ff066a"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81feb6b6764613b662160e4396c1f6e76c299dfcd51cd173753448061dc03194"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81feb6b6764613b662160e4396c1f6e76c299dfcd51cd173753448061dc03194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81feb6b6764613b662160e4396c1f6e76c299dfcd51cd173753448061dc03194"
    sha256 cellar: :any_skip_relocation, ventura:        "4bad6229f7b3e25ec404e37c32c0de261faaa10dc481bc2fe14131a1154c56f3"
    sha256 cellar: :any_skip_relocation, monterey:       "4bad6229f7b3e25ec404e37c32c0de261faaa10dc481bc2fe14131a1154c56f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bad6229f7b3e25ec404e37c32c0de261faaa10dc481bc2fe14131a1154c56f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81feb6b6764613b662160e4396c1f6e76c299dfcd51cd173753448061dc03194"
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
