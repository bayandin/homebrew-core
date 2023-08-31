require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.76.0.tgz"
  sha256 "3016fa72326685554c75f5224adfd7c2e2adedc953902d3dfe820b99a6729c51"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862ed87f0a8b68e288f82751603a0fa93a4d536e0a6b85e4c40989928fc833ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92eb9d2fc41d13b79b14e8cf06fb9d5caf85445e547723dd73b0d60d559d8de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26a26010181b43f434edf3b924040f56339983ef03070c2fd47429efe3d87c8c"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b16dcd15be5ee2b603bb5da59a01df9042b1dde6fa19b2a7ef1dfdda81bb6a"
    sha256 cellar: :any_skip_relocation, monterey:       "b32c42159338a7563a5f52136bbb2a1943bfcdf0d8316091977656aa8ea4d2aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ae72c73b8f8188c269789ae86aacb7561bbaeed353e5974ad7bf5bda8b420cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86a16651532316a96bda165d4c4ae2e13b7c1fa0e3b84ec764f702b3adf7827"
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
