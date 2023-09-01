class TfProfile < Formula
  desc "CLI tool to profile Terraform runs"
  homepage "https://github.com/datarootsio/tf-profile"
  url "https://github.com/datarootsio/tf-profile/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9f505b980149c8ffe29089f772391a9230bf6527f18ad56eb158305d752e1ee8"
  license "MIT"
  head "https://github.com/datarootsio/tf-profile.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "netgo", *std_go_args(ldflags: "-s -w")
    pkgshare.install "test"

    generate_completions_from_executable(bin/"tf-profile", "completion")
  end

  test do
    test_file = pkgshare/"test/argo.log"
    output = shell_output("#{bin}/tf-profile stats #{test_file}")
    assert_match "Number of resources in configuration   100", output
    assert_match "Resources not in desired state         2 out of 76 (2.6%)", output

    output = shell_output("#{bin}/tf-profile table #{test_file}")
    assert_match "tot_time  modify_started  modify_ended", output

    assert_match version.to_s, shell_output("#{bin}/tf-profile version")
  end
end
