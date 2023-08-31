class TerraformGraphBeautifier < Formula
  desc "CLI to beautify `terraform graph` output"
  homepage "https://github.com/pcasteran/terraform-graph-beautifier"
  url "https://github.com/pcasteran/terraform-graph-beautifier/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "81aa8580423c09fbfe2e83a1d52fa9821ba0fe744b08b3d8219d2174a0c86e13"
  license "Apache-2.0"
  head "https://github.com/pcasteran/terraform-graph-beautifier.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    pkgshare.install "test"
  end

  test do
    test_file = (pkgshare/"test/config1_expected.gv").read
    output = pipe_output("#{bin}/terraform-graph-beautifier --graph-name=test --output-type=graphviz", test_file)
    assert_equal test_file, output

    assert_match version.to_s, shell_output("#{bin}/terraform-graph-beautifier -v")
  end
end
