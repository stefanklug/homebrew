require 'formula'

class Openscenegraph < Formula
  url 'http://www.openscenegraph.org/svn/osg/OpenSceneGraph/tags/OpenSceneGraph-3.0.1/', :using => :svn
  version '3.0.1'
  homepage 'http://www.openscenegraph.org/'

  depends_on 'cmake'
  depends_on 'jpeg'
  depends_on 'wget'
  depends_on 'ffmpeg' => :optional
  depends_on 'gdal' => :optional
  depends_on 'jasper' => :optional
  depends_on 'openexr' => :optional
  depends_on 'collada' => :optional
  depends_on 'dcmtk' => :optional
  depends_on 'librsvg' => :optional

  def install
    args = ["..", "-DCMAKE_INSTALL_PREFIX='#{prefix}'", "-DCMAKE_BUILD_TYPE=None", "-Wno-dev", "-DBUILD_OSG_WRAPPERS=ON", "-DBUILD_DOCUMENTATION=ON"]
    if snow_leopard_64?
      args << "-DCMAKE_OSX_ARCHITECTURES=x86_64"
      args << "-DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio"
      args << "-DOSG_WINDOWING_SYSTEM=Cocoa"
    else
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
    end

    if Formula.factory('collada').installed?
      args << "-DCOLLADA_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include/collada-dom"
    end

    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake", *args
      system "make install"
    end
  end

  def patches
    # The mini-Boost finder in FindCOLLADA doesn't find our boost, so fix it.
    return DATA
  end

end

__END__
Index: CMakeModules/FindCOLLADA.cmake
===================================================================
--- a/CMakeModules/FindCOLLADA.cmake	(revision 12824)
+++ b/CMakeModules/FindCOLLADA.cmake	(working copy)
@@ -235,7 +235,7 @@
     )
 
     FIND_LIBRARY(COLLADA_BOOST_FILESYSTEM_LIBRARY
-        NAMES libboost_filesystem boost_filesystem libboost_filesystem-vc90-mt libboost_filesystem-vc100-mt
+        NAMES libboost_filesystem boost_filesystem boost_filesystem-mt libboost_filesystem-vc90-mt libboost_filesystem-vc100-mt
         PATHS
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/${COLLADA_BUILDNAME}
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/mingw
@@ -251,7 +251,7 @@
     )
 
     FIND_LIBRARY(COLLADA_BOOST_SYSTEM_LIBRARY
-        NAMES libboost_system boost_system libboost_system-vc90-mt libboost_system-vc100-mt
+        NAMES libboost_system boost_system boost_system-mt libboost_system-vc90-mt libboost_system-vc100-mt
         PATHS
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/${COLLADA_BUILDNAME}
         ${COLLADA_DOM_ROOT}/external-libs/boost/lib/mingw