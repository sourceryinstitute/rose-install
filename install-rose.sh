#!/usr/bin/env bash
#
# install-rose.sh
#
# -- This script installs the ROSE compiler infrastructure.
#
# Copyright (c) 2018, Sourcery Institute
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this
#    list of conditions and the following disclaimer in the documentation and/or
#    other materials provided with the distribution.
# 3. Neither the names of the copyright holders nor the names of their contributors
#    may be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Portions of this script derive from BASH3 Boilerplate and are distributed under
# the following license:
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Kevin van Zonneveld
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
#  - https://github.com/kvz/bash3boilerplate
#  - http://kvz.io/blog/2013/02/26/introducing-bash3boilerplate/
#
# Version: 2.0.0
#
# Authors:
#
#  - Kevin van Zonneveld (http://kvz.io)
#  - Izaak Beekman (https://izaakbeekman.com/)
#  - Alexander Rathai (Alexander.Rathai@gmail.com)
#  - Dr. Damian Rouson (http://www.sourceryinstitute.org/) (documentation)
#
# Licensed under MIT
# Copyright (c) 2013 Kevin van Zonneveld (http://kvz.io)

# The invocation of bootstrap.sh below performs the following tasks:
# (1) Import several bash3boilerplate helper functions & default settings.
# (2) Set several variables describing the current file and its usage page.
# (3) Parse the usage information (default usage file name: current file's name with -usage appended).
# (4) Parse the command line using the usage information.

### Start of boilerplate -- do not edit this block #######################
export ROSE_INSTALLER_SRC_DIR="${ROSE_INSTALLER_SRC_DIR:-${PWD%/}}"
if [[ ! -f "${ROSE_INSTALLER_SRC_DIR}/install-rose.sh" ]]; then
  echo "Please run this script inside the top-level rose-installer source directory or "
  echo "set ROSE_INSTALLER_SRC_DIR to the rose-installer source directory path."
  exit 1
fi
export B3B_USE_CASE="${B3B_USE_CASE:-${ROSE_INSTALLER_SRC_DIR}/bash3boilerplate-use-case}"
if [[ ! -f "${B3B_USE_CASE:-}/bootstrap.sh" ]]; then
  echo "Please set B3B_USE_CASE to the bash3boilerplate-use-case directory path."
  exit 2
else
    source "${B3B_USE_CASE}/bootstrap.sh" "$@"
fi
### End of boilerplate -- start user edits below #########################

# Set expected value of present flags that take no arguments
export __flag_present=1

# Set up a function to call when receiving an EXIT signal to do some cleanup. Remove if
# not needed. Other signals can be trapped too, like SIGINT and SIGTERM.
function cleanup_before_exit () {
  info "Cleaning up. Done"
}
trap cleanup_before_exit EXIT # The signal is specified here. Could be SIGINT, SIGTERM etc.


### Validation (decide what's required for running your script and error out)

[ -z "${LOG_LEVEL:-}" ] && emergency "Cannot continue without LOG_LEVEL. "

# The remainder of this file is organized into three sections:
# 1. Command-line argument and environment variable processing.
# 2. Function definitions.
# 3. Main body.

# __________ Process command-line arguments and environment variables _____________

### Print bootstrapped magic variables to STDERR when LOG_LEVEL
### is at the default value (6) or above.
{
info "__file: ${__file}"
info "__dir: ${__dir}"
info "__base: ${__base}"
info "__os: ${__os}"
info "__usage: ${__usage}"
info "LOG_LEVEL: ${LOG_LEVEL}"

info  "-d (--debug):            ${arg_d}"
info  "-e (--verbose):          ${arg_e}"
info  "-h (--help):             ${arg_h}"
info  "-j (--num-threads):      ${arg_j}"
}
this_script="$(basename "$0")"
export this_script

export num_threads="${arg_j}"
info "num_threads=\"${arg_j}\""

# ___________________ Define functions for use in the Main Body ___________________

# (none defined at present)

# ___________________ End of function definitions for use in the Main Body __________________


# ________________________________ Start of the Main Body ___________________________________

export boost_version=1.68.0
export boost_install_prefix=/opt/boost/$boost_version
export boost_major_version=${boost_version%%.*}
export boost_minor_patch=${boost_version#*.}
export boost_minor_version=${boost_minor_patch%%.*}
export boost_patch_version=${boost_version##*.}
export boost_src_dir="boost_${boost_major_version}_${boost_minor_version}_${boost_patch_version}"
export boost_tar_ball="${boost_src_dir}.tar.bz2"

sudo apt install vim gfortran g++ vim bison flex make automake libtool zlib1g-dev libpng-dev default-jdk

info "Installing Boost"

if [[ -f "$boost_tar_ball" ]]; then
  info "Found ${boost_tar_ball}.  Skipping download."
else
  wget https://dl.bintray.com/boostorg/release/${boost_version}/source/${boost_tar_ball}
fi

if [[ -d "$boost_src_dir" ]]; then
  info "Found ${boost_src_dir}.  Skipping decompression and expansion."
else
  info "Expanding ${boost_tar_ball}"
  tar xf "${boost_tar_ball}" || emergency "$boost_tar_ball did not expand. Maybe file is corrupted or incomplete."
fi

cd "${boost_src_dir}"|| emergency "'cd $boost_src_dir' failed. Does the directory exist & do you have permission to open it?"

./bootstrap.sh \
  --prefix=$boost_install_prefix \
  --with-libraries=chrono,date_time,filesystem,iostreams,program_options,random,regex,signals,system,thread,wave
sudo ./b2 --prefix=$boost_install_prefix install

info "Installing Oracle Java Developemnt Kit 7, update 51"
if [[ ! -f ~/Downloads/jdk-7u51-linux-x64.tar.bz2 ]]; 
  info "Use a web browser to download the Java Development Kit 7 Update 51 (try https://bit.ly/2N4XLMj). Restart this"
  emergency "script (${this_script}) after placing the downloaded file (jdk-7u51-linux-x64.tar.bz2) in ${HOME}/Downloads."
fi
sudo mkdir -p /usr/lib/jvm
cd /usr/lib/jvm
tar xf ~/Downloads/jdk-7u51-linux-x64.tar.bz2
sudo ln -s jdk1.7.0_51 java-7-sun
cd java-7-sun/bin
for f in $(find . -maxdepth 1 -type f -perm -500 -printf '%f\n'); do \
    [ "$f" != "./apt" ] && sudo update-alternatives --install /usr/bin/$f $f /usr/lib/jvm/java-7-sun/bin/$f 1072; \
done

echo -e "$this_script: Ok to remove /usr/bin/javac? (Y/n) "
read -r proceed_with_build

if [[ "$proceed_with_removal" == "n" || "$proceed_with_removal" == "no" ]]; then
  info "n"
  emergency "$this_script: I'm not sure if installation can succeed without removing /usr/bin/javac so I'm cowardly quitting."
else 
  info "Y"
fi
sudo rm /usr/bin/javac
sudo ln -s `pwd`/javac /usr/bin/javac

export javac_version=$(javac -version)
if [[ "$javac_version" != "javac 1.7.0_51" ]]; then
   emergency "Incorrect javac version: $javac_version"
fi

## install ROSE
#
cd ${HOME}/ROSE
git clone https://github.com/rose-compiler/rose-develop rose-fortran-dev
export ROSE_SRC=${HOME}/ROSE/rose-fortran-dev
export ROSE_BLD=${HOME}/ROSE/build-rose-fortran-dev
export ROSE_INSTALL=${HOME}/ROSE/install-rose-fortran-dev
cd ${ROSE_SRC} && ./build
mkdir ${ROSE_BLD}
cd ${ROSE_BLD}

export config="--with-C_DEBUG=-g --with-C_OPTIMIZE=-O0 --with-CXX_DEBUG=-g --with-CXX_OPTIMIZE=-O0 \
--with-boost=${boost_install_prefix} --disable-boost-version-check \
--prefix=${ROSE_INSTALL} \
--enable-edg_version=4.12 \
--enable-languages=c,c++,fortran \
--with-ROSE_LONG_MAKE_CHECK_RULE=yes "

FC=gfortran CC=cc CXX=c++ "${ROSE_SRC}/configure" $config
make -j ${num_threads}
sudo make install
