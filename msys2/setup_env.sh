#!/bin/bash



# About this script.
# --------------------------------------------------------------------
# This script configures environment variables for msys2 to target the
# visual studio 64bit platform.
# All other platforms are targeted by adjusting the CMake toolchain files
# or other CMake files.
# The CMake toolchain files specify the compilers, while the other CMake
# files should adjust their paths according to the value of the ARCH variable.

# How to use this script.
# --------------------------------------------------------------------
# In your msys2 .bashrc file, simply source the setup_env.sh script in this directory.
# source /e/src/devscripts/msys2/setup_env.sh


# Adjust these local variables to accomodate your environment.
# --------------------------------------------------------------------
# This assumes you have divided your programs/libraries into those that
# used a windows based installer vs those that were simply unpacked/unzipped.
export INSTALLS_DIR=/e/installs
export UNPACKS_DIR=/e/unpacks



# Determine some helpful variables.
# --------------------------------------------------------------------
# Get the directory of this script.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
# This example shows how to make a relative path into an absolute one.
#TEST_DIR=`readlink -f ${SCRIPT_DIR}/../../..`
#echo "test dir: ${TEST_DIR}"


# Script Locations.
# --------------------------------------------------------------------

# Add the dir for this script so that other existing or future scripts can be called.
PATH=${SCRIPT_DIR}:${PATH}



# Base programs are expected to installed to their default locations.
# --------------------------------------------------------------------

# Java Setup.
export JAVA_HOME="/c/Program Files/Java/jdk1.8.0_144"
PATH="/c/Program Files/Java/jdk1.8.0_144/bin":${PATH}

# Git
PATH="/c/Program Files/Git/bin":${PATH}

# CMake
PATH="/c/Program Files/CMake/bin":${PATH}

# Path for xxd, which is part of vim for windows
PATH="/c/Program Files (x86)/Vim/vim80":${PATH}



# Programs unpacked for specialized development.
# --------------------------------------------------------------------

# Jom build tool
PATH=${UNPACKS_DIR}/jom_1_1_2:${PATH}

# Ninja build tool
PATH=${UNPACKS_DIR}/ninja-win-1.8.2:${PATH}

# Eclipse
PATH=${UNPACKS_DIR}/eclipse:${PATH}

# Ant
PATH=${UNPACKS_DIR}/apache-ant-1.10.1/bin:${PATH}



# Programs installed for specialized development.
# --------------------------------------------------------------------

# Setup android variables.
export ANDROID_SDK_ROOT=${INSTALLS_DIR}/android-sdk
export ANDROID_NDK_ROOT=${INSTALLS_DIR}/android-ndk-r10e
export ANDROID_TOOLCHAIN_ROOT=${INSTALLS_DIR}/android_toolchain

# Android platform tools
PATH=${INSTALLS_DIR}/android-sdk/platform-tools:${PATH}
  
