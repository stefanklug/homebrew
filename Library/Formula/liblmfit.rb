require 'formula'

class Liblmfit < Formula
  url 'http://joachimwuttke.de/src/lmfit-3.2.tgz'
  homepage 'http://joachimwuttke.de/lmfit/'
  md5 'f3fe8962c120fb08938cbe907fb58616'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
