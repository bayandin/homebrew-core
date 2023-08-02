class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v21.12.0.tar.gz"
  sha256 "4001b4c49661ca8b71baf915e773341e115d154077bef218433a3c1d72ee4f0c"
  license "MPL-2.0"

  head do
    url "https://github.com/gismo/gismo.git", branch: "stable"
  end

  depends_on "cmake" => :build
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "superlu"

  on_macos do
    depends_on "libomp"
  end

  def install
    ENV.runtime_cpu_detection

    args = std_cmake_args
    args << "-DBLA_VENDOR=OpenBLAS"
    args << "-DGISMO_WITH_SUPERLU=ON"
    args << "-DGISMO_WITH_UMFPACK=ON"

    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
    end
    args << "-DGISMO_WITH_OPENMP=ON"

    if OS.mac?
      args << "-DTARGET_ARCHITECTURE=apple-m1" if Hardware::CPU.arm?
      args << "-DTARGET_ARCHITECTURE=penryn"   if Hardware::CPU.intel?
    elsif OS.linux?
      args << "-DTARGET_ARCHITECTURE=penryn"   if Hardware::CPU.intel?
    end

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gismo.h>
      using namespace gismo;
      int main()
      {
        gsInfo.precision(3);
        gsVector<> v(4);
        gsMatrix<> M(2,4);
        v.setOnes();
        M.setOnes();
        gsInfo << M*v << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/gismo", "-std=c++14", "-o", "test"
    assert_equal %w[4 4], shell_output("./test").split
  end
end
