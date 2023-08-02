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
    args = []
    args.push("-DBLA_VENDOR=OpenBLAS")

    args.push("-DSUPERLUDIR=#{Formula["superlu"].opt_prefix}")
    args.push("-DGISMO_WITH_SUPERLU=ON")

    args.push("-DUMFPACKDIR=#{Formula["suite-sparse"].opt_prefix}")
    args.push("-DGISMO_WITH_UMFPACK=ON")

    args.push("-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_include}") if OS.mac?
    args.push("-DGISMO_WITH_OPENMP=ON")

    target_arch =
      case Hardware.oldest_cpu
      when :arm_vortex_tempest then "apple-m1"
      when :core2 then "penryn"
      else "generic"
      end
    args.push("-DTARGET_ARCHITECTURE=#{target_arch}")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
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
