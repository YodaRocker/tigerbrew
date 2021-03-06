class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.4.3.tar.gz"
  sha256 "efbe0d58fda936f2ed99d0b837ed7087d064d6838931f282c4618d2a3f7390c4"

  bottle do
    cellar :any
    sha256 "f40ebbbb4a92ed580fab324f26160b58f9456d17deaf4e138852e394a72f2084" => :tiger_altivec
    sha256 "14cd48734271f4f7236a06a83de069b30848b7147b71924646fd09f79ee26261" => :leopard_g3
    sha256 "0b7953dfbedccc64b3047677f885b3e7890a6b6df368ec52dec07bd40dc4d041" => :leopard_altivec
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :optional
  depends_on "giflib" => :optional

  def install
    system "./autogen.sh" if build.head?

    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--enable-libwebpmux",
                          "--enable-libwebpdemux",
                          "--enable-libwebpdecoder",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system "#{bin}/dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert File.exist?("webp_test.webp")
  end
end
