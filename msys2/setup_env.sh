#!/bin/bash

# --------------------------------------------------------------------
# About this script.
# --------------------------------------------------------------------
# This script configures msys2 environment variables to target the
# visual studio 64bit platform.


# --------------------------------------------------------------------
# How to use this script.
# --------------------------------------------------------------------
# In your msys2 .bashrc file, simply source the setup_env.sh script 
# in this directory.
# source /c/dev/src/devscripts/msys2/setup_env.sh


# --------------------------------------------------------------------
# Adjust these local variables to accomodate your environment.
# --------------------------------------------------------------------
# This assumes you have divided your programs/libraries into those that
# used a windows based installer vs those that were simply unpacked/unzipped.
export INSTALLS_DIR=/c/installs
export UNPACKS_DIR=/c/unpacks
export WINDOWS_PROGRAMS="/c/Program Files"
export WINDOWS_PROGRAMS_X86="/c/Program Files (x86)"

# The directory containing this script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# This example shows how to make a relative path into an absolute one.
#TEST_DIR=`readlink -f ${SCRIPT_DIR}/../../..`
#echo "test dir: ${TEST_DIR}"


# --------------------------------------------------------------------
# Our helper functions.
# --------------------------------------------------------------------
prepend_library_path() {
  LD_LIBRARY_PATH=$1:${LD_LIBRARY_PATH}
}
prepend_path() {
  PATH=$1:${PATH}
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
PATH=${UNPACKS_DIR}/jom_1_1_2:${PATH}

# Ninja build tool
PATH=${UNPACKS_DIR}/ninja-win-1.8.2:${PATH}

# Eclipse
PATH=${UNPACKS_DIR}/eclipse:${PATH}

# Ant
PATH=${UNPACKS_DIR}/apache-ant-1.10.1/bin:${PATH}

# Arnold
export ARNOLD_PATH=${UNPACKS_DIR}/Arnold-5.0.2.4-windows
prepend_library_path ${ARNOLD_PATH}/lib
prepend_path ${ARNOLD_PATH}/bin

# --------------------------------------------------------------------
# Our custom built programs.
# -------------------------------------------------------------------
source ${SCRIPT_DIR}/third_party.sh

