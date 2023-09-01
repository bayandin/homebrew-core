class AlsaLib < Formula
  desc "Provides audio and MIDI functionality to the Linux operating system"
  homepage "https://www.alsa-project.org/"
  url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.10.tar.bz2"
  sha256 "c86a45a846331b1b0aa6e6be100be2a7aef92efd405cf6bac7eef8174baa920e"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.alsa-project.org/files/pub/lib/"
    regex(/href=.*?alsa-lib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "3ccd8d2162aaaf5fd81ddaad0b5def06fb3053245b6b7ee77019e1620502ad7b"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <alsa/asoundlib.h>
      int main(void)
      {
          snd_ctl_card_info_t *info;
          snd_ctl_card_info_alloca(&info);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lasound", "-o", "test"
    system "./test"
  end
end
