class LdidProcursus < Formula
  desc "Put real or fake signatures in a Mach-O binary"
  homepage "https://github.com/ProcursusTeam/ldid"
  url "https://github.com/ProcursusTeam/ldid.git",
     tag:      "v2.1.5-procursus7",
     revision: "aaf8f23d7975ecdb8e77e3a8f22253e0a2352cef"
  version "2.1.5-procursus7"
  license "AGPL-3.0-or-later"
  head "https://github.com/ProcursusTeam/ldid.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "openssl@3"

  conflicts_with "ldid", because: "ldid installs a conflicting ldid binary"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    zsh_completion.install "_ldid"
  end

  test do
    cp test_fixtures("mach/a.out"), testpath
    system bin/"ldid", "-S", "a.out"
  end
end
