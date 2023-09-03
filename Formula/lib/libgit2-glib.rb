class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  license "LGPL-2.1-only"
  revision 2
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  stable do
    url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.1.0/libgit2-glib-v1.1.0.tar.bz2"
    sha256 "6cbbf43eda241cc8602fc22ccd05bbc4355d9873634bc12576346e6b22321f03"

    # Add commit signing API. Needed for dependent `gitg`.
    # Remove with `stable` block on next release.
    patch do
      url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/commit/7f36e18f41e0b28b35c85fe8bf11d844a0001305.diff"
      sha256 "e5a07c6bbd05b88f1d52107167d7db52f43abfd0b367645cc75b72acb623d9ff"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "3e00a33f2d6fcaa935590ae471c1b6b0887b96a5bf04a142207dc4b861db5bcd"
    sha256 cellar: :any, arm64_monterey: "df185c6c3ef129cfd1862cdeccd0cbb712d96cd8c4533ca5216174ffc6213981"
    sha256 cellar: :any, arm64_big_sur:  "d1fad3cf7352dc4e9da32662c94ddf1c44b5c5fd69531929113aaac5a5555045"
    sha256 cellar: :any, ventura:        "91b431c40146fa729d6847aea26ee93ab0c2d90230daafc5014fbfdd1fda5435"
    sha256 cellar: :any, monterey:       "70757d1a95a3eafad006d22bc47814212e53d074523f1717567c1c18f45d8b98"
    sha256 cellar: :any, big_sur:        "c37882210af3f421dabdb2244c50b8a113ed10cde71313a8c4098fe24029258d"
    sha256               x86_64_linux:   "47ca5a8b0430ec37b60fb19d54d87bc9c65b778e0e234151b2d4873b7789e0cb"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", "setup", "build", *std_meson_args,
                                      "-Dpython=false",
                                      "-Dvapi=true"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    libexec.install (buildpath/"build/examples").children
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
