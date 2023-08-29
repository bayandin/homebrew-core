class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.13/libxmlb-0.3.13.tar.xz"
  sha256 "ae45ae4c0606f94d98fea16b7097b3470e48c2f277954ae9bc4d9d029ed72496"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  def install
    rewrite_shebang detected_python_shebang, "src/generate-version-script.py"

    system "meson", "setup", "build",
                    "-Dgtkdoc=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/xb-tool", "-h"
    (testpath/"test.c").write <<~EOS
      #include <xmlb.h>
      int main(int argc, char *argv[]) {
        XbBuilder *builder = xb_builder_new();
        g_assert_nonnull(builder);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    xz = Formula["xz"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libxmlb-2
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{xz.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lxmlb
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
