class Mgis < Formula
  desc "Provide tools to handle MFront generic interface behaviours"
  homepage "https://thelfer.github.io/mgis/web/index.html"
  url "https://github.com/thelfer/MFrontGenericInterfaceSupport/archive/refs/tags/MFrontGenericInterfaceSupport-2.1.tar.gz"
  sha256 "f5b556aab130da0c423f395fe4c35d6bf509dd8fc958242f2e37ea788464aea9"
  license any_of: ["LGPL-3.0-only", "CECILL-1.0"]
  head "https://github.com/thelfer/MFrontGenericInterfaceSupport.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    args = [
      "-Denable-portable-build=ON",
      "-Denable-website=OFF",
      "-Denable-enable-doxygen-doc=OFF",
      "-Denable-c-bindings=ON",
      "-Denable-fortran-bindings=ON",
      "-Denable-python-bindings=ON",  # requires boost-python
      "-Denable-fenics-bindings=OFF", # experimental and very limited
      "-Denable-julia-bindings=OFF",  # requires CxxWrap library
      "-Denable-enable-static=OFF",
      "-Ddisable_python_library_linking=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", "import mgis.behaviour"
    system python3, "-c", "import mgis.model"
  end
end
