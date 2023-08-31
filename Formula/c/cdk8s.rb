require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.68.1.tgz"
  sha256 "e2963e8dbab539cbb130ebcd34db736c8c3ea7b436bb6443fd1670f44e06845f"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60725f8eb8c2b0acc1e35cf7a61a224235c0b5a551bd13a4c96b28994eb4c338"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60725f8eb8c2b0acc1e35cf7a61a224235c0b5a551bd13a4c96b28994eb4c338"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60725f8eb8c2b0acc1e35cf7a61a224235c0b5a551bd13a4c96b28994eb4c338"
    sha256 cellar: :any_skip_relocation, ventura:        "52e1064f4f50d754f536a16dc511bef384a462e02cf4df13b972219d1a71a6e9"
    sha256 cellar: :any_skip_relocation, monterey:       "52e1064f4f50d754f536a16dc511bef384a462e02cf4df13b972219d1a71a6e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "52e1064f4f50d754f536a16dc511bef384a462e02cf4df13b972219d1a71a6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60725f8eb8c2b0acc1e35cf7a61a224235c0b5a551bd13a4c96b28994eb4c338"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
