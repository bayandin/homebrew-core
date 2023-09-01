class Jreleaser < Formula
  desc "Release projects quickly and easily with JReleaser"
  homepage "https://jreleaser.org/"
  url "https://github.com/jreleaser/jreleaser/releases/download/v1.8.0/jreleaser-1.8.0.zip"
  sha256 "9b9c0c7b4e07cd058593114111a1ddaaa752937308d85216666f64ce1d588d1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34b0dfb280377d460c31b0674f8d51e0d1f9addf3e6496d31ae9de0133a20477"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"jreleaser").write_env_script libexec/"bin/jreleaser", Language::Java.overridable_java_home_env
  end

  test do
    expected = <<~EOS
      [INFO]  Writing file #{testpath}/jreleaser.toml
      [INFO]  JReleaser initialized at #{testpath}
    EOS
    assert_match expected, shell_output("#{bin}/jreleaser init -f toml")
    assert_match "description = \"Awesome App\"", (testpath/"jreleaser.toml").read

    assert_match "jreleaser #{version}", shell_output("#{bin}/jreleaser --version")
  end
end
