class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.hugeping.ru/"
  url "https://github.com/instead-hub/instead/archive/3.5.1.tar.gz"
  sha256 "53380f94be7f1ec46de309d513f7fe62a1c63d607a247715d87815e83a9c7d63"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "bd3d94207c0f3cf11525c91a066428272fe9533e4266f39bcf1fdfa9b95ed09a"
    sha256 arm64_monterey: "ab640922ca125be86535d8f18e72cf627ff9f5de3f390c96fb292c0a0722c2c1"
    sha256 arm64_big_sur:  "a8567211438e9a45b56c0a382b962a1ac6effa993a98041107b5493fc2bb2b9c"
    sha256 ventura:        "22cb3c9c276bd60055fa50082ac04e97eb80e767ce4f71e1da734a7b09e4ff08"
    sha256 monterey:       "84137b216b1c8cb4ef4f886fceee77234d98f58af5dd355f8da95bcaf9a8e281"
    sha256 big_sur:        "a007eb402aa5a2d9b4dcd27e404531154ea2a5aafb917694eb977016e5aeeafd"
    sha256 catalina:       "36074d03fe68d4f958e0370f9fa06cbf933334d049aa35bf496bcaca7e13a17d"
    sha256 x86_64_linux:   "ca65cb49260b64f9338df21fad6ffa48e63a6605b59b1e9135a43b9b6d856d73"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "luajit"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_GTK2=OFF",
                    "-DWITH_LUAJIT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "INSTEAD #{version} ", shell_output("#{bin}/instead -h 2>&1")
  end
end
