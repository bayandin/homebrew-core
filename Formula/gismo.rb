class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v21.12.0.tar.gz"
  sha256 "4001b4c49661ca8b71baf915e773341e115d154077bef218433a3c1d72ee4f0c"
  license "MPL-2.0"

  head do
    url "https://github.com/gismo/gismo.git", branch: "stable"

    depends_on "cmake" => :build
  end

  option "with-mpi",     "Enable MPI parallelization"
  option "with-superlu", "Enable SuperLU support"
  option "with-umfpack", "Enable Umfpack support"

  option "without-openmp", "Disable OpenMP parallelization"

  depends_on "cmake" => :build
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "openblas"
  depends_on "suite-sparse" if build.with? "umfpack"
  depends_on "superlu" => :optional

  unless build.without? "openmp"
    on_macos do
      depends_on "libomp"
    end
  end

  def install
    args = std_cmake_args << "-DBLA_VENDOR=OpenBLAS"
    args << "-DGISMO_WITH_MPI=ON" if build.with? "mpi"
    args << "-DGISMO_WITH_SUPERLU=ON" if build.with? "superlu"
    args << "-DGISMO_WITH_UMFPACK=ON" if build.with? "umfpack"

    unless build.without? "openmp"
      if OS.mac?
        libomp = Formula["libomp"]
        args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
        args << "-DOpenMP_C_LIB_NAMES=omp"
        args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
        args << "-DOpenMP_CXX_LIB_NAMES=omp"
        args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
      end
      args << "-DGISMO_WITH_OPENMP=ON"
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
