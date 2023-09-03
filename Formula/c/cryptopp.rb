class Cryptopp < Formula
  desc "Free C++ class library of cryptographic schemes"
  homepage "https://cryptopp.com/"
  url "https://cryptopp.com/cryptopp880.zip"
  mirror "https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_8_0/cryptopp880.zip"
  version "8.8.0"
  sha256 "ace1c7b010a409eba5e86c4fd5a8845c43a6ac39bb6110e64ca5d7fea08583f4"
  license all_of: [:public_domain, "BSL-1.0"]
  head "https://github.com/weidai11/cryptopp.git", branch: "master"

  livecheck do
    url :head
    regex(/^CRYPTOPP[._-]V?(\d+(?:[._-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  def install
    ENV.cxx11
    system "make", "all", "libcryptopp.pc"
    system "make", "test"
    system "make", "install-lib", "PREFIX=#{prefix}"
  end

  test do
    # Test program modified from:
    #   https://www.cryptopp.com/wiki/Advanced_Encryption_Standard
    (testpath/"test.cc").write <<~EOS
      #ifdef NDEBUG
      #undef NDEBUG
      #endif
      #include <cassert>
      #include <iostream>
      #include <string>

      #include <cryptopp/cryptlib.h>
      #include <cryptopp/modes.h>
      #include <cryptopp/osrng.h>
      #include <cryptopp/rijndael.h>

      int main(int argc, char *argv[]) {
        using namespace CryptoPP;

        AutoSeededRandomPool prng;

        SecByteBlock key(AES::DEFAULT_KEYLENGTH);
        SecByteBlock iv(AES::BLOCKSIZE);

        prng.GenerateBlock(key, key.size());
        prng.GenerateBlock(iv, iv.size());

        std::string plain = "Hello, Homebrew!";
        std::string cipher;
        std::string recovered;

        try {
          CBC_Mode<AES>::Encryption e;
          e.SetKeyWithIV(key, key.size(), iv);
          StringSource s(plain, true,
              new StreamTransformationFilter(e, new StringSink(cipher)));
        } catch (const Exception &e) {
          std::cerr << e.what() << std::endl;
          exit(1);
        }

        try {
          CBC_Mode<AES>::Decryption d;
          d.SetKeyWithIV(key, key.size(), iv);
          StringSource s(cipher, true,
              new StreamTransformationFilter(d, new StringSink(recovered)));
        } catch (const Exception &e) {
          std::cerr << e.what() << std::endl;
          exit(1);
        }

        assert(plain == recovered);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lcryptopp", "-o", "test"
    system "./test"
  end
end
