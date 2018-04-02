#!/bin/bash

# --------------------------------------------------------------------
# About this script.
# --------------------------------------------------------------------
# This script configures msys2 environment variables.
# This assumes you have divided your programs/libraries into those that
# used a windows based installer vs those that were simply unpacked/unzipped.

# Adjust these local variables to accomodate your environment.
export INSTALLS_DIR=/c/installs
export UNPACKS_DIR=/c/unpacks
export WINDOWS_PROGRAMS="/c/Program Files"
export WINDOWS_PROGRAMS_X86="/c/Program Files (x86)"

# --------------------------------------------------------------------
# How to use this script.
# --------------------------------------------------------------------
# In your msys2 .bashrc file, simply source the setup_env.sh script 
# in this directory.
# source /c/dev/src/devscripts/msys2/setup_env.sh

# --------------------------------------------------------------------
# Dependencies.
# --------------------------------------------------------------------
# This script assumes you have the following in your unpacks dir.
# apache-ant-1.10.1
# Arnold-5.0.2.4
# eclipse
# ispc-v1.9.2-windows
# jom_1_1_2
# ninja-win-1.8.2

# This script assumes you have the following in your installs dir.
# msys2
# Qt/Qt5.10.1 (note the subdirectory, to allow multiple versions)

# The directory containing this script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# This example shows how to make a relative path into an absolute one.
#TEST_DIR=`readlink -f ${SCRIPT_DIR}/../../..`
#echo "test dir: ${TEST_DIR}"


# --------------------------------------------------------------------
# Our helper functions.
# --------------------------------------------------------------------

# Prepend the LD_LIBRARY_PATH with an absolute path.
prepend_library_path() {
  LD_LIBRARY_PATH=$1:${LD_LIBRARY_PATH}
}

# Prepend the executable search path with an absolute path.
prepend_path() {
  PATH=$1:${PATH}
}

# Prepend environment paths with binaries for custom built project. 
prepend_env() {
  # The .lib files are usually placed in the lib dirs.
  LD_LIBRARY_PATH=${INSTALL_DIR}/$1/lib:${LD_LIBRARY_PATH}
  # Sometimes the dlls are placed into the lib dir, so we add this to the path as well.
  PATH=${INSTALL_DIR}/$1/lib:${PATH}
  # Executables are usually placed in the bin dirs.
  PATH=${INSTALL_DIR}/$1/bin:${PATH}
}

# --------------------------------------------------------------------
# Our paths.
# --------------------------------------------------------------------

# Our devscripts directory.
prepend_path ${SCRIPT_DIR}


# --------------------------------------------------------------------
# Common or basic programs are expected to installed to their default locations.
# --------------------------------------------------------------------

# Java Setup.
export JAVA_HOME=${WINDOWS_PROGRAMS}/Java/jdk1.8.0_144
prepend_path "${JAVA_HOME}/bin"

# Git
prepend_path "${WINDOWS_PROGRAMS}/Git/bin"

# CMake
prepend_path "${WINDOWS_PROGRAMS}/CMake/bin"

# Path for xxd, which is part of vim for windows
prepend_path "${WINDOWS_PROGRAMS_X86}/Vim/vim80"

# Python 2.7.14
prepend_path "/c/Python27"

# gVim 80
prepend_path "${WINDOWS_PROGRAMS_X86}/Vim/vim80"


# --------------------------------------------------------------------
# Programs for development.
# --------------------------------------------------------------------

# Jom build tool
prepend_path ${UNPACKS_DIR}/jom_1_1_2

# Ninja build tool
prepend_path ${UNPACKS_DIR}/ninja-win-1.8.2

# Eclipse
prepend_path ${UNPACKS_DIR}/eclipse

# Ant
prepend_path ${UNPACKS_DIR}/apache-ant-1.10.1/bin

# Enbree
prepend_path ${UNPACKS_DIR}/ispc-v1.9.2-windows

# Arnold
export ARNOLD_PATH=${UNPACKS_DIR}/Arnold-5.0.2.4-windows
prepend_library_path ${ARNOLD_PATH}/lib
prepend_path ${ARNOLD_PATH}/bin

# --------------------------------------------------------------------
# Load compiler specific env variables. 
# --------------------------------------------------------------------
source ${SCRIPT_DIR}/${LLL_VS_ENV}_env.sh

