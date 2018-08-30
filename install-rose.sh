#!/usr/bin/env bash

export JAVA_HOME=/usr/lib/jvm/java-7-sun
export BOOST_HOME=/opt/boost/1.68.0
export boost_major=1
export boost_minor=68
export boost_patch=0
export boost_version="${boost_major}.${boost_minor}.${boost_patch}"
export boost_src_dir="boost_${boost_major}_${boost_major}_${boost_patch}"
export boost_tar_ball="${boost_tar_ball}.tar.bz2"

sudo apt install vim gfortran g++ vim bison flex make
sudo apt install automake libtool zlib1g-dev
sudo apt install libpng-dev
wget https://dl.bintray.com/boostorg/release/${boost_version}/source/${boost_src_dir}
tar xf "${boost_tar_ball}"
cd boost_1_68_0
./bootstrap.sh \
  --prefix=$BOOST_HOME \
  --with-libraries=chrono,date_time,filesystem,iostreams,program_options,random,regex,signals,system,thread,wave
sudo ./b2 --prefix=$BOOST_HOME install
sudo apt-get install default-jdk

## install Java Developemnt Kit 7, update 51
#
if [[ ! -f ~/Downloads/jdk-7u51-linux-x64.tar.bz2 ]]; 
  echo "Use a web browser to download the Java Development Kit 7 Update 51"
  echo "(try https://bit.ly/2N4XLMj) and place the downloaded file"
  echo "(jdk-7u51-linux-x64.tar.bz2) in ${HOME}/Downloads."
  exit 1;
fi
mkdir -p /usr/lib/jvm
cd /usr/lib/jvm
sudo tar xf ~/Downloads/jdk-7u51-linux-x64.tar.bz2
sudo ln -s jdk1.7.0_51 java-7-sun
cd java-7-sun/bin
for f in $(find . -maxdepth 1 -type f -perm -500 -printf '%f\n'); do \
    [ "$f" != "./apt" ] && sudo update-alternatives --install /usr/bin/$f $f /usr/lib/jvm/java-7-sun/bin/$f 1072; \
done

sudo rm /usr/bin/javac
sudo ln -s `pwd`/javac /usr/bin/javac

export javac_version=$(javac -version)
if [[ "$javac_version" != "javac 1.7.0_51" ]]; then
	echo "Incorrect javac version: $javac_version"
	exit 1
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
--with-boost=${BOOST_HOME} --disable-boost-version-check \
--prefix=${ROSE_INSTALL} \
--enable-edg_version=4.12 \
--enable-languages=c,c++,fortran \
--with-ROSE_LONG_MAKE_CHECK_RULE=yes "

FC=gfortran CC=cc CXX=c++ "${ROSE_SRC}/configure" $config
make
sudo make install
