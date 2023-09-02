class RuffLsp < Formula
  include Language::Python::Virtualenv

  desc "Language Server Protocol implementation for Ruff"
  homepage "https://github.com/astral-sh/ruff-lsp"
  url "https://files.pythonhosted.org/packages/5e/0f/e2d43ebd62f1cabb64b542d8c8171d17187fff3bffc4ad118f85b0801c72/ruff_lsp-0.0.38.tar.gz"
  sha256 "55589a042777c5d42e222d77d91c0f6ccbac8d818aecb3005c1a24170a1568ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd648d5a255eede70e3d3e5b3b36b31db313750f92ef03b5a7e98b3ef9053686"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a129b07d5ed7d0e47ed32f9d0647b937296e75a2a7d5239abd93765aa608cd60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "985aab9a2b37fff6a3837dae9a50ed7cbd907bec6ccf4afbf41efbab0ca91986"
    sha256 cellar: :any_skip_relocation, ventura:        "815a5e1736c1b0851df12a7211ce98acd5a1d29c613c3961bb4ec1f27647688a"
    sha256 cellar: :any_skip_relocation, monterey:       "2a653cb39106c355b0c900a814d1f74236471482c6e7dab08937bf2f2052fe2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "edece0f482e4ae865baaa4c573eed5c5fe45e64a9448d324391a43b0fbf4c1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ec683833df6e16f168e627454a39b7af6be2fb33a8d71db340a79f9082742a"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "ruff"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/68/d4/27f9fd840e74d51b6d6a024d39ff495b56ffde71d28eb82758b7b85d0617/cattrs-23.1.2.tar.gz"
    sha256 "db1c821b8c537382b2c7c66678c3790091ca0275ac486c76f3c8f3920e83c657"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/1c/a3/146d67e3433bacda203206284fdb420468b89dfd8afc5a710a73bc6a5ace/lsprotocol-2023.0.0a3.tar.gz"
    sha256 "d704e4e00419f74bece9795de4b34d02aa555fc0131fec49f59ac9eb46816e51"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/bb/c4/fc9c817ba0f1ad0fdbe1686bc8211a0dc2390ab11cf7780e9eeed718594b/pygls-1.0.2.tar.gz"
    sha256 "888ed63d1f650b4fc64d603d73d37545386ec533c0caac921aed80f80ea946a4"
  end

  resource "typeguard" do
    url "https://files.pythonhosted.org/packages/af/40/3398497c6e6951c92abaf933492d6633e7ac4df0bfc9d81f304b3f977f15/typeguard-3.0.2.tar.gz"
    sha256 "fee5297fdb28f8e9efcb8142b5ee219e02375509cd77ea9d270b5af826358d5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruff-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
