require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.71.0.tgz"
  sha256 "278a15c5261505aa05a9f87c11d959a16553b4c9d70df8558bd7154de743ef86"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2345acc3e4ab93b3ecab117630d25eeb5cce26e1ae384ff71409d7f63e4c20be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2345acc3e4ab93b3ecab117630d25eeb5cce26e1ae384ff71409d7f63e4c20be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2345acc3e4ab93b3ecab117630d25eeb5cce26e1ae384ff71409d7f63e4c20be"
    sha256 cellar: :any_skip_relocation, ventura:        "aa7e11f122a0b9c6e46fcfe38a57c9c3c836229ac45e6bd8091bc624ff398515"
    sha256 cellar: :any_skip_relocation, monterey:       "aa7e11f122a0b9c6e46fcfe38a57c9c3c836229ac45e6bd8091bc624ff398515"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa7e11f122a0b9c6e46fcfe38a57c9c3c836229ac45e6bd8091bc624ff398515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2345acc3e4ab93b3ecab117630d25eeb5cce26e1ae384ff71409d7f63e4c20be"
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
