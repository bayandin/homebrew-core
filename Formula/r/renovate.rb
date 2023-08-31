require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.78.0.tgz"
  sha256 "f9b1f856b1f9100f04ecb122b6b033f348429fcc7372438566ad03fb4c29b2bf"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cde6661eec44a3874553a6406105b8f1e3393cf8dd80ca051ae444db548c433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd17a54882fa13fad21e5b9320ffad95a02cb9f7f4957dd48e4af5690cc55e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da0cb9ca04970ef1cc5748c6a15d95ea194f1d0fc0c1f2cc67b7461cd42d060e"
    sha256 cellar: :any_skip_relocation, ventura:        "0749b1b50a5dc6c403df46ae608d25dd732116e4685b9e1f9a91f8edef49abdc"
    sha256 cellar: :any_skip_relocation, monterey:       "b43bcb5164419b552aff8cb4f62fa6a3bc594b84abbd8bf977baf61731bb1b71"
    sha256 cellar: :any_skip_relocation, big_sur:        "d447ca4af1f0df7fc6eb5df5118cf415388d9381fabdacde319eace607ccc0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17626834639f7bf771df6ea46fb39eedb1838f6f0681b47c8173c6375b70fe09"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
