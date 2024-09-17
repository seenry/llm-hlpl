### REQUIRES FLANG TO HAVE BEEN INSTALLED

export HERE=`pwd`
export INSTALL_PREFIX=$HERE/install

export AUTOMAKE_VER=1.17 # check https://www.gnu.org/software/automake for latest version
export AUTOCONF_VER=2.72 # check https://www.gnu.org/software/autoconf for latest version
export LIBTOOL_VER=2.4.7 # check https://www.gnu.org/software/libtool for latest version

##### DEPENDENCIES #####
# autoconf (mpi dep)
cd $HERE
wget https://mirror.team-cymru.com/gnu/autoconf/autoconf-$AUTOCONF_VER.tar.gz
tar xzvf autoconf-$AUTOCONF_VER.tar.gz
rm autoconf-$AUTOCONF_VER.tar.gz
cd $HERE/autoconf-$AUTOCONF_VER
./configure --prefix=$INSTALL_PREFIX
make -j"$(nproc)" && make install

# automake (mpi dep)
cd $HERE
wget https://mirrors.ocf.berkeley.edu/gnu/automake/automake-$AUTOMAKE_VER.tar.gz
tar xzvf automake-$AUTOMAKE_VER.tar.gz
rm automake-$AUTOMAKE_VER.tar.gz
cd $HERE/automake-$AUTOMAKE_VER
./configure --prefix=$INSTALL_PREFIX
make -j"$(nproc)" && make install

# libtool (mpi dep)
cd $HERE
wget https://ftp.wayne.edu/gnu/libtool/libtool-$LIBTOOL_VER.tar.gz
tar xzvf libtool-$LIBTOOL_VER.tar.gz
rm libtool-$LIBTOOL_VER.tar.gz
cd $HERE/libtool-$LIBTOOL_VER
./configure --prefix=$INSTALL_PREFIX
make -j"$(nproc)" && make install

##### MPICH #####
cd $HERE
git clone --recursive git@github.com:pmodels/mpich.git
cd $HERE/mpich
export BASE_PATH=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$INSTALL_PREFIX/lib:$BASE_PATH
./autogen.sh --with-autotools=$INSTALL_PREFIX/bin
./configure --prefix=$INSTALL_PREFIX \
            CC=$INSTALL_PREFIX/bin/clang \
            CXX=$INSTALL_PREFIX/bin/clang++ \
            FC=$INSTALL_PREFIX/bin/flang
make -j"$(nproc)" && make install

export LD_LIBRARY_PATH=$BASE_PATH
unset BASE_PATH
unset HERE
unset INSTALL_PREFIX
unset AUTOMAKE_VER
unset AUTOCONF_VER
unset LIBTOOL_VER

