#!/bin/bash

# By default msys2 will not have many tools.
# Do the following to install tar, zip and unzip.
# pacman -S tar
# pacman -S zip
# pacman -S unzip

DOWNLOAD_DIR=/c/dev/downloads
SRC_DIR=/c/dev/src
BUILD_DIR=/c/dev/builds
BUILD_INSTALLS_DIR=/c/dev/builds/installs

# Prepend environment paths with binaries for custom built project. 
prepend_env() {
  # The .lib files are usually placed in the lib dirs.
  LD_LIBRARY_PATH=${BUILD_INSTALLS_DIR}/$1/lib:${LD_LIBRARY_PATH}
  # Sometimes the dlls are placed into the lib dir, so we add this to the path as well.
  PATH=${BUILD_INSTALLS_DIR}/$1/lib:${PATH}
  # Executables are usually placed in the bin dirs.
  PATH=${BUILD_INSTALLS_DIR}/$1/bin:${PATH}
}

# Add MSBuild.exe onto the path.
prepend_path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin"

enter_build_dir() {
  lib_name=$1
  cd ${BUILD_DIR}
  rm -fr ${lib_name} 
  mkdir -p ${lib_name} 
  cd ${lib_name}
}

# Cmake configure options.
DEBUG_OPT="-DCMAKE_BUILD_TYPE=Debug"
SHARED_OPT="-DBUILD_SHARED_LIBS=1"
POSTFIX_OPT="-DCMAKE_DEBUG_POSTFIX=d"
DEFAULT_OPTS="${DEBUG_OPT} ${SHARED_OPT}"

configure() {
  lib_name=$1
  opts=${@:2}
  echo -G"Eclipse CDT4 - Ninja" ${opts} -DCMAKE_INSTALL_PREFIX=${BUILD_INSTALLS_DIR}/${lib_name} ${SRC_DIR}/${lib_name}
  cmake -G"Eclipse CDT4 - Ninja" ${opts} -DCMAKE_INSTALL_PREFIX=${BUILD_INSTALLS_DIR}/${lib_name} ${SRC_DIR}/${lib_name}
}

build(){
  ninja
  ninja install
}

download_all() {
  download_zlib
  download_ilmbase
  download_openexr
  download_tiff
  download_libpng
  download_libjpeg-cmake
  download_boost
  download_oiio
  download_glew
  download_tbb
  download_embree
}
unpack_all() {
  unpack_zlib
  unpack_ilmbase
  unpack_openexr
  unpack_tiff
  unpack_libpng
  unpack_libjpeg-cmake
  unpack_boost
  unpack_oiio
  unpack_glew
  unpack_tbb
  unpack_embree
}
build_all() {
  build_zlib
  build_ilmbase
  build_openexr
  build_tiff
  build_libpng
  build_libjpeg-cmake
  build_boost
  build_oiio
  build_glew
  build_tbb
  build_embree
}


# ----------------------------------------------------------------------
# Source specific build routines.
# Note that cmake should be able to most of the dependencies on its own
# using the paths that we prepend for each library.
# ----------------------------------------------------------------------

prepend_env zlib-1.2.11
download_zlib() {
  cd ${DOWNLOAD_DIR}
  wget "https://zlib.net/zlib-1.2.11.tar.gz"
}
unpack_zlib() {
  cd ${SRC_DIR}
  rm -fr zlib-1.2.11
  tar -xzvf ${DOWNLOAD_DIR}/zlib-1.2.11.tar.gz
}
build_zlib() {
  enter_build_dir zlib-1.2.11
  configure zlib-1.2.11 ${DEFAULT_OPTS}
  build
}

# ----------------------------------------------------------------------

prepend_env ilmbase-2.2.1
download_ilmbase() {
  cd ${DOWNLOAD_DIR}
  wget "http://download.savannah.nongnu.org/releases/openexr/ilmbase-2.2.1.tar.gz"
}
unpack_ilmbase() {
  cd ${SRC_DIR}
  rm -fr ilmbase-2.2.1
  tar -xzvf ${DOWNLOAD_DIR}/ilmbase-2.2.1.tar.gz
}
build_ilmbase() {
  enter_build_dir ilmbase-2.2.1
  configure ilmbase-2.2.1 ${DEFAULT_OPTS}
  build
  # ilmbase requires extra tweaks to build
  cd Half
  cp ${SRC_DIR}/ilmbase-2.2.1/Half/toFloat.cpp .
  cp ${SRC_DIR}/ilmbase-2.2.1/Half/eLut.cpp .
  cl.exe toFloat.cpp
  cl.exe eLut.cpp
  ./toFloat.exe > toFloat.h
  ./eLut.exe > eLut.h
  cd ..
  build
}

# ----------------------------------------------------------------------

prepend_env openexr-2.2.1
download_openexr() {
  cd ${DOWNLOAD_DIR}
  wget "http://download.savannah.nongnu.org/releases/openexr/openexr-2.2.1.tar.gz"
}
unpack_openexr() {
  cd ${SRC_DIR}
  rm -fr openexr-2.2.1
  tar -xzvf ${DOWNLOAD_DIR}/openexr-2.2.1.tar.gz
}
build_openexr() {
  enter_build_dir openexr-2.2.1
  extra_opts="-DILMBASE_PACKAGE_PREFIX=C:\dev\builds\installs\ilmbase-2.2.1 "
  configure openexr-2.2.1 ${DEFAULT_OPTS} ${extra_opts}
  build
}

# ----------------------------------------------------------------------

prepend_env tiff-4.0.9
download_tiff() {
  cd ${DOWNLOAD_DIR}
  wget "ftp://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz"
}
unpack_tiff() {
  cd ${SRC_DIR}
  rm -fr tiff-4.0.9
  tar -xzvf ${DOWNLOAD_DIR}/tiff-4.0.9.tar.gz
}
build_tiff() {
  enter_build_dir tiff-4.0.9
  configure tiff-4.0.9 ${DEFAULT_OPTS}
  build
}

# ----------------------------------------------------------------------

prepend_env libpng-1.6.34
download_libpng() {
  cd ${DOWNLOAD_DIR}
  wget "https://download.sourceforge.net/libpng/libpng-1.6.34.tar.gz"
}
unpack_libpng() {
  cd ${SRC_DIR}
  rm -fr libpng-1.6.34
  tar -xzvf ${DOWNLOAD_DIR}/libpng-1.6.34.tar.gz
}
build_libpng() {
  enter_build_dir libpng-1.6.34
  configure libpng-1.6.34 ${DEFAULT_OPTS}
  build
}

# ----------------------------------------------------------------------

prepend_env libjpeg-cmake
download_libjpeg-cmake() {
  echo "no downloads .. using a git repo"
}
unpack_libjpeg-cmake() {
  cd ${SRC_DIR}
  rm -fr libjpeg-cmake
  git clone https://github.com/stohrendorf/libjpeg-cmake.git
}
build_libjpeg-cmake() {
  enter_build_dir libjpeg-cmake
  # This won't configure properly when BUILD_SHARED_LIBS is set to True.
  configure libjpeg-cmake ${DEBUG_OPT}
  build
  # Note this fails for some reason.
  # However after this just run cmake-gui/configure+generate and it will build.
}

# ----------------------------------------------------------------------

# Use the boost_build.bat file to build boost.
prepend_library_path ${SRC_DIR}/boost_1_66_0/stage/x64/lib
prepend_path ${SRC_DIR}/boost_1_66_0/stage/x64/lib

download_boost() {
  cd ${DOWNLOAD_DIR}
  wget "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.zip"
}
unpack_boost() {
  cd ${SRC_DIR}
  rm -fr boost_1_66_0
  unzip ${DOWNLOAD_DIR}/boost_1_66_0.zip
}
build_boost() {
  cp -f ${SRC_DIR}/devscripts/msys2/build_boost.bat ${SRC_DIR}/boost_1_66_0
  cp -f ${SRC_DIR}/devscripts/msys2/user-config.jam C:/Users/`whoami`
  cd ${SRC_DIR}/boost_1_66_0
  build_boost.bat
}

# ----------------------------------------------------------------------

prepend_env oiio
download_oiio() {
  echo "no downloads .. using a git repo"
}
unpack_oiio() {
  cd ${SRC_DIR}
  rm -fr oiio
  git clone https://github.com/OpenImageIO/oiio.git
}
build_oiio() {
  enter_build_dir oiio
  extra_opts="-DBoost_INCLUDE_DIR=/c/dev/src/boost_1_66_0 \
	  -DBoost_ATOMIC_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_atomic-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_ATOMIC_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_atomic-vc141-mt-x64-1_66.lib \
	  -DBoost_CHRONO_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_chrono-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_CHRONO_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_chrono-vc141-mt-x64-1_66.lib \
	  -DBoost_DATE_TIME_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_date_time-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_DATE_TIME_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_date_time-vc141-mt-x64-1_66.lib \
	  -DBoost_FILESYSTEM_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_filesystem-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_FILESYSTEM_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_filesystem-vc141-mt-x64-1_66.lib \
	  -DBoost_REGEX_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_regex-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_REGEX_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_regex-vc141-mt-x64-1_66.lib \
	  -DBoost_SYSTEM_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_filesystem-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_SYSTEM_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_filesystem-vc141-mt-x64-1_66.lib \
	  -DBoost_THREAD_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_thread-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_THREAD_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/boost_thread-vc141-mt-x64-1_66.lib \
	  "
  configure oiio ${DEFAULT_OPTS} ${extra_opts}
  build
}

# ----------------------------------------------------------------------

# GLEW needs to be built with visual studio 
prepend_library_path ${SRC_DIR}/glew-2.1.0/lib/Debug/x64
prepend_path ${SRC_DIR}/glew-2.1.0/lib/Debug/x64
prepend_library_path ${SRC_DIR}/glew-2.1.0/lib/Release/x64
prepend_path ${SRC_DIR}/glew-2.1.0/lib/Release/x64
prepend_path ${SRC_DIR}/glew-2.1.0/bin/Debug/x64
prepend_path ${SRC_DIR}/glew-2.1.0/bin/Release/x64
download_glew() {
  cd ${DOWNLOAD_DIR}
  wget "https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.zip"
}
unpack_glew() {
  cd ${SRC_DIR}
  rm -fr glew-2.1.0
  unzip ${DOWNLOAD_DIR}/glew-2.1.0.zip
}
build_glew() {
  cd ${SRC_DIR}/glew-2.1.0/build/vc12
  # Upgrade the solution file to vs2017.
  devenv.exe glew.sln //upgrade
  # Build the debug and release configurations.
  msbuild.exe glew.sln //property:Configuration=Debug //property:Platform=x64
  msbuild.exe glew.sln //property:Configuration=Release //property:Platform=x64
}

# ----------------------------------------------------------------------

# Appleseed (This is not working.)
prepend_env appleseed
build_appleseed() {
  enter_build_dir appleseed 
  CXXFLAGS=-I/c/dev/builds/installs/ilmbase-2.2.1/include -I/c/dev/builds/installs/libjpeg-cmake/include -I/c/dev/builds/installs/libpng-1.6.34/include -I/c/dev/builds/installs/oiio/include -I/c/dev/builds/installs/openexr-2.2.1/include -I/c/dev/builds/installs/openexr-2.2.1/include/OpenEXR -I/c/dev/builds/installs/tiff-4.0.9/include -I/c/dev/builds/installs/zlib-1.2.11/include
  extra_opts="-DBoost_INCLUDE_DIR=/c/dev/src/boost_1_66_0 \
	  -DBoost_ATOMIC_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_atomic-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_ATOMIC_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_atomic-vc141-mt-x64-1_66.lib \
	  -DBoost_CHRONO_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_chrono-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_CHRONO_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_chrono-vc141-mt-x64-1_66.lib \
	  -DBoost_DATE_TIME_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_date_time-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_DATE_TIME_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_date_time-vc141-mt-x64-1_66.lib \
	  -DBoost_FILESYSTEM_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_filesystem-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_FILESYSTEM_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_filesystem-vc141-mt-x64-1_66.lib \
          -DBoost_PYTHON_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_python-vc141-mt-gd-x64-1_66.lib \
          -DBoost_PYTHON_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_python-vc141-mt-x64-1_66.lib \
	  -DBoost_REGEX_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_regex-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_REGEX_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_regex-vc141-mt-x64-1_66.lib \
	  -DBoost_SERIALIZATION_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_serialization-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_SERIALIZATION_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_serialization-vc141-mt-x64-1_66.lib \
	  -DBoost_SYSTEM_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_filesystem-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_SYSTEM_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_filesystem-vc141-mt-x64-1_66.lib \
	  -DBoost_THREAD_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_thread-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_THREAD_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_thread-vc141-mt-x64-1_66.lib \
	  -DBoost_WAVE_LIBRARY_DEBUG=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_wave-vc141-mt-gd-x64-1_66.lib \
	  -DBoost_WAVE_LIBRARY_RELEASE=/c/dev/src/boost_1_66_0/stage/x64/lib/libboost_wave-vc141-mt-x64-1_66.lib \
	  -DWITH_STUDIO=0 \
	  "
  configure appleseed ${DEFAULT_OPTS} ${extra_opts}
  build
  
  # -DGLEW_INCLUDE_DIR=/c/dev/src/glew-2.1.0/include \
  # -DGLEW_LIBRARY=/c/dev/src/glew-2.1.0/lib/Debug/x64/glew32d.lib \
}

# ----------------------------------------------------------------------

# TBB
# TBB has no CMakeLists.txt so you'll need to build with Visual Stuio.
# Build all the x64 configs. Then copy the DEBUG-MT and RELEASE-M makefile.slnT
# contents into a lib dir at top of the source dir.
prepend_library_path ${SRC_DIR}/tbb-2018_U3/lib
prepend_path ${SRC_DIR}/tbb-2018_U3/lib
download_tbb() {
  cd ${DOWNLOAD_DIR}
  wget "https://github.com/01org/tbb/archive/2018_U3.tar.gz"
}
unpack_tbb() {
  cd ${SRC_DIR}
  rm -fr tbb-2018_U3
  tar -xzvf ${DOWNLOAD_DIR}/2018_U3.tar.gz
}
build_tbb() {
  cd ${SRC_DIR}/tbb-2018_U3/build/vs2013
  # Upgrade the solution file to vs2017.
  devenv.exe makefile.sln //upgrade
  # Build the debug and release configurations.
  msbuild.exe makefile.sln //property:Configuration=Debug-MT  //property:Platform=x64
  msbuild.exe makefile.sln //property:Configuration=Release-MT  //property:Platform=x64
  mkdir -p ${SRC_DIR}/tbb-2018_U3/lib
  cd x64
  cd Debug-MT
  cp -f * ${SRC_DIR}/tbb-2018_U3/lib
  cd ../Release-MT
  cp -f * ${SRC_DIR}/tbb-2018_U3/lib
}

# ----------------------------------------------------------------------

# Embree
prepend_env embree-3.0.0
download_embree() {
  cd ${DOWNLOAD_DIR}
  wget "https://github.com/embree/embree/archive/v3.0.0.tar.gz"
}
unpack_embree() {
  cd ${SRC_DIR}
  rm -fr embree-3.0.0
  tar -xzvf ${DOWNLOAD_DIR}/v3.0.0.tar.gz
}
build_embree() {
  enter_build_dir embree-3.0.0
  opts=-DEMBREE_TBB_ROOT="${SRC_DIR}/tbb-2018_U3 -DEMBREE_ISPC_SUPPORT=ON -DEMBREE_TUTORIALS_LIBJPEG=OFF"
  configure embree-3.0.0 ${DEFAULT_OPTS} ${opts}
  build
}

# ----------------------------------------------------------------------

# This doesn't work.
# Qt 5.10.1
prepend_env qt-5.10.1
download_qt() {
  cd ${DOWNLOAD_DIR}
  wget "http://download.qt.io/official_releases/qt/5.10/5.10.1/single/qt-everywhere-src-5.10.1.zip"
}
unpack_qt() {
  cd ${SRC_DIR}
  rm -fr qt-everywhere-src-5.10.1
  unzip ${DOWNLOAD_DIR}/qt-everywhere-src-5.10.1.zip
}
build_qt() {
  cd ${SRC_DIR}/qt-everywhere-src-5.10.1
  cp -f ${SRC_DIR}/devscripts/msys2/build_qt.bat .
  ./build_qt.bat . 
}


