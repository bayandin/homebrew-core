class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      tag:      "v0.4.6",
      revision: "b40b5da5a570155298335e276839a41588337b5d"
  license "GPL-3.0-only"
  head "https://github.com/OpenRCT2/OpenRCT2.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "72637787ddf5c8721bfab362617a3288648d999859768933f068c2b7156c09da"
    sha256 cellar: :any, arm64_monterey: "557e40ac89ba94bda1fbd6042f93af02e318122ab5569ec81ad10e6e8c3299b5"
    sha256 cellar: :any, arm64_big_sur:  "e3afce28e6afc31a8492422a11d0c8ac398be3822e43646830456f1aa230e302"
    sha256 cellar: :any, ventura:        "7b86442ea907babb8b9cb4aca9c9c7d87b49da956e636a8f26978da2f0524d1a"
    sha256 cellar: :any, monterey:       "9f0a3a7b60b1a5b2db0babef47c99dcef65e39a84507d72b6771fb34389caf65"
    sha256 cellar: :any, big_sur:        "227baa4bd735425c65b9ee0ca312562f4cedd78ae61e560a8261e1b23470d0af"
    sha256               x86_64_linux:   "441e0c42fa6325fbbcfa38d17eb20747f9a0d6dc31e2453202358f14f02889b0"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkg-config" => :build
  depends_on "duktape"
  depends_on "flac"
  depends_on "freetype"
  depends_on "icu4c"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on macos: :mojave # `error: call to unavailable member function 'value': introduced in macOS 10.14`
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "speexdsp"

  on_linux do
    depends_on "curl"
    depends_on "fontconfig"
    depends_on "mesa"
  end

  fails_with gcc: "5" # C++17

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.4.6/title-sequences.zip"
    sha256 "24a189cdaf1f78fb6d6caede8f1ab3cedf8ab9f819cd2260a09b2cce4c710d98"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.3.11/objects.zip"
    sha256 "bf85d88e4fb11ca2e5915567390898747dc2459b3c7a057bdc32b829c91780b4"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}",
                            "-DWITH_TESTS=OFF",
                            "-DDOWNLOAD_TITLE_SEQUENCES=OFF",
                            "-DDOWNLOAD_OBJECTS=OFF",
                            "-DMACOS_USE_DEPENDENCIES=OFF",
                            "-DDISABLE_DISCORD_RPC=ON"
      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct2-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
