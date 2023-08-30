class Libjcat < Formula
  include Language::Python::Shebang

  desc "Library for reading Jcat files"
  homepage "https://github.com/hughsie/libjcat"
  url "https://github.com/hughsie/libjcat/releases/download/0.1.14/libjcat-0.1.14.tar.xz"
  sha256 "702706d75ff0c7253d0f5697bdd482e8c2cfe9909749fc7d68ddb364730b7383"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libjcat.git", branch: "main"

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "json-glib"

  def install
    rewrite_shebang detected_python_shebang, "contrib/generate-version-script.py"
    rewrite_shebang detected_python_shebang, "contrib/build-certs.py"

    system "meson", "setup", "build",
                    "-Dgpg=false",
                    "-Dman=false",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/jcat-tool", "-h"
    (testpath/"test.c").write <<~EOS
      #include <jcat.h>
      int main(int argc, char *argv[]) {
        JcatContext *ctx = jcat_context_new();
        g_assert_nonnull(ctx);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gnutls = Formula["gnutls"]
    flags = %W[
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libjcat-1
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gnutls.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ljcat
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
