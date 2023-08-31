class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "b0e38671975c0871f1b9a7bacba376f90ecb429973cb4b5b9cf90a3f4e072304"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b3c03d60987c8ef28db8b23ded7d3dfadb13652935062c4eee0c590c0287ed1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f659a67330d7268e0208368ea517ef29bf9333e13a1028a3bfc9bd29427e2b67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0232f2fa4c4cfee5e46a4bbb3ec5bd332bdbde6cbba7fa83a5a535e5a4919ced"
    sha256 cellar: :any_skip_relocation, ventura:        "88211b45c615f37a878f0a174a6cdac52ddc38bd45881a9b321185806d8d0481"
    sha256 cellar: :any_skip_relocation, monterey:       "3769918ebf11460955b4e06f25ddd9dd78398005de7f6fb5d1742a8e7eea7935"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a121bc8d0338e10148bd73acb49874b632ccd008df171b893098e7df33305be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69d39eb352308a01344ec1d2c65bab0f22c6009c4b366012250b3999c5511c5"
  end

  # upstream bug report for building with go1.21, https://github.com/anchore/syft/issues/2066
  depends_on "go@1.20" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=brew
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check")
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end
