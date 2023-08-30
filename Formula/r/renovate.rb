require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.74.0.tgz"
  sha256 "ad8149ae5a086130d433da58301c80c3046731e685233713b147805779dc7de0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "608cd1fe34cc642274d1100e17926a5b14fd94bd64d098f1c39de9ecb32623a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96f20222bc9f34a1e94eb371c7f10249281a06e64be4404a5f73667de2add787"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46af4b6fdf4fe54e49a3c9e4bec3ffa026a2c5426a8d484c933047fcfc7462c6"
    sha256 cellar: :any_skip_relocation, ventura:        "5faa341796febf07ee50779fae0235429667693d7c3cd529738132069f5f33c4"
    sha256 cellar: :any_skip_relocation, monterey:       "23928e2aefc90ce929778538eb68d52865509d54c6df834c2c17ab3bd3804e24"
    sha256 cellar: :any_skip_relocation, big_sur:        "6294cc82f3476dff4c45a682993e68cbb3ac77a59560d4329d70314866fa24b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b42fa84aa0db4897b826c03c46ffc86d223a5adad28721283304e2a8f15c784d"
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
