#!/bin/bash

SRC_DIR=/c/dev/src
BUILD_DIR=/c/dev/builds
INSTALL_DIR=/c/dev/builds/installs

prepend_env() {
  # The .lib files are usually placed in the lib dirs.
  LD_LIBRARY_PATH=${INSTALL_DIR}/$1/lib:${LD_LIBRARY_PATH}
  # Sometimes the dlls are placed into the lib dir, so we add this to the path as well.
  PATH=${INSTALL_DIR}/$1/lib:${PATH}
  # Executables are usually placed in the bin dirs.
  PATH=${INSTALL_DIR}/$1/bin:${PATH}
}


enter_build_dir() {
  lib_name=$1
  cd ${BUILD_DIR}
  rm -fr ${lib_name} 
  mkdir -p ${lib_name} 
  cd ${lib_name}
}

configure() {
  other_opts=$@
  echo "other_opts: ${other_opts}"
  cmake -G"NMake Makefiles" \
	-DBUILD_SHARED_LIBS=1 \
	-DCMAKE_BUILD_TYPE=Debug \
	-DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}/${lib_name} \
  	${other_opts} \
	${SRC_DIR}/${lib_name}
  # removed options
  # -DCMAKE_DEBUG_POSTFIX=d \
}

build(){
  ninja
  ninja install
}

# ----------------------------------------------------------------------
# Source specific build routines.
# Note that cmake should be able to most of the dependencies on its own
# using the paths that we prepend for each library.
# ----------------------------------------------------------------------

prepend_env zlib-1.2.11
build_zlib() {
  enter_build_dir zlib-1.2.11
  configure zlib-1.2.11
  build
}

prepend_env ilmbase-2.2.1
build_ilmbase() {
  enter_build_dir ilmbase-2.2.1
  configure ilmbase-2.2.1
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

prepend_env openexr-2.2.1
build_openexr() {
  enter_build_dir openexr-2.2.1
  opts="-DILMBASE_PACKAGE_PREFIX=C:\dev\builds\installs\ilmbase-2.2.1 "
  configure ${opts}
  build
}

prepend_env tiff-4.0.9
build_tiff() {
  enter_build_dir tiff-4.0.9
  configure
  build
}

prepend_env libpng-1.6.34
build_libpng() {
  enter_build_dir libpng-1.6.34
  configure
  build
}

prepend_env libjpeg-cmake
build_libjpeg-cmake() {
  enter_build_dir libjpeg-cmake
  configure
  build
  # Note this fails for some reason.
  # However after this just run cmake-gui/configure+generate and it will build.
}

# Use the boost_build.bat file to build boost.
prepend_library_path ${SRC_DIR}/boost_1_66_0/stage/x64/lib
prepend_path ${SRC_DIR}/boost_1_66_0/stage/x64/lib

prepend_env oiio
build_oiio() {
  enter_build_dir oiio
  opts="-DBoost_INCLUDE_DIR=/c/dev/src/boost_1_66_0 \
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
  configure ${opts}
  build
}

# GLEW needs to be build with visual studio 14.1
prepend_library_path ${SRC_DIR}/glew-2.1.0/lib/Debug/x64
prepend_path ${SRC_DIR}/glew-2.1.0/lib/Debug/x64
prepend_library_path ${SRC_DIR}/glew-2.1.0/lib/Release/x64
prepend_path ${SRC_DIR}/glew-2.1.0/lib/Release/x64
prepend_path ${SRC_DIR}/glew-2.1.0/bin/Debug/x64
prepend_path ${SRC_DIR}/glew-2.1.0/bin/Release/x64

# Appleseed
prepend_env appleseed
build_appleseed() {
  enter_build_dir appleseed 
  CXXFLAGS=-I/c/dev/builds/installs/ilmbase-2.2.1/include -I/c/dev/builds/installs/libjpeg-cmake/include -I/c/dev/builds/installs/libpng-1.6.34/include -I/c/dev/builds/installs/oiio/include -I/c/dev/builds/installs/openexr-2.2.1/include -I/c/dev/builds/installs/openexr-2.2.1/include/OpenEXR -I/c/dev/builds/installs/tiff-4.0.9/include -I/c/dev/builds/installs/zlib-1.2.11/include
  opts="-DBoost_INCLUDE_DIR=/c/dev/src/boost_1_66_0 \
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
  configure ${opts}
  build
  
  # -DGLEW_INCLUDE_DIR=/c/dev/src/glew-2.1.0/include \
  # -DGLEW_LIBRARY=/c/dev/src/glew-2.1.0/lib/Debug/x64/glew32d.lib \
}
