class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/MobileNativeFoundation/bluepill"
  url "https://github.com/MobileNativeFoundation/bluepill.git",
      tag:      "v5.12.3",
      revision: "a7fcb47aa61b7be6732193c82b697719bf11b813"
  license "BSD-2-Clause"
  head "https://github.com/MobileNativeFoundation/bluepill.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40c2789182add578ede8a68a27a47ab9a6910ed7a79fc1991c9edebf4062e5e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcee67bb312cd0ae7bcabc30dd64dafde41e3fe2f32fac25d28ce50e7f1da455"
    sha256 cellar: :any_skip_relocation, ventura:        "620c47806c862b57184492fc17164e35c2c734e7f91e1c28ad830a978b160764"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6c74a7d099e09ec8ce11f56539bb1d25d5854ad4fb3b4b583360137ab103b5"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    pbxprojs = ["bluepill", "bp"].map { |name| "#{name}/#{name}.xcodeproj/project.pbxproj" }
    inreplace pbxprojs, "x86_64", Hardware::CPU.arch.to_s

    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "SYMROOT=../",
               "ARCHS=#{Hardware::CPU.arch}"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
