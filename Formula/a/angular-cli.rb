require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.1.tgz"
  sha256 "e5fc35d70ca0b6753102196fa93c28cb07a2238971ae2342bb123af442d63bda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
    sha256 cellar: :any_skip_relocation, ventura:        "580b6efc4c730a841eddae07553d91074b83e9493282b441d7a72e4fd903dc5e"
    sha256 cellar: :any_skip_relocation, monterey:       "580b6efc4c730a841eddae07553d91074b83e9493282b441d7a72e4fd903dc5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "580b6efc4c730a841eddae07553d91074b83e9493282b441d7a72e4fd903dc5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
