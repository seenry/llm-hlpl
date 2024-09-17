export HERE=`pwd`
export INSTALL_PREFIX=$HERE/install

export CMAKE_VER=3.30.3 # check https://cmake.org/download for latest version
export CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
                      -DCMAKE_BUILD_TYPE=Release \
                      -DCMAKE_CXX_COMPILER=$INSTALL_PREFIX/bin/clang++ \
                      -DCMAKE_C_COMPILER=$INSTALL_PREFIX/bin/clang \
                      -DCMAKE_Fortran_COMPILER=$INSTALL_PREFIX/bin/flang \
                      -DCMAKE_Fortran_COMPILER_ID=Flang \
                      -DLLVM_TARGETS_TO_BUILD=X86"

##### DEPENDENCIES #####
# cmake (llvm/flang dep)
cd $HERE
wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VER/cmake-$CMAKE_VER.tar.gz
tar xzvf cmake-$CMAKE_VER.tar.gz
rm cmake-$CMAKE_VER.tar.gz
cd $HERE/cmake-$CMAKE_VER
./configure --prefix=$INSTALL_PREFIX
gmake -j"$(nproc)"
make -j"$(nproc)" && make install

# llvm (flang dep)
cd $HERE
git clone -b release_16x https://github.com/flang-compiler/classic-flang-llvm-project.git
cd $HERE/classic-flang-llvm-project
mkdir -p build && cd build
$INSTALL_PREFIX/bin/cmake $CMAKE_OPTIONS -DCMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
                          -DLLVM_ENABLE_CLASSIC_FLANG=ON -DLLVM_ENABLE_PROJECTS="clang;openmp" ../llvm
make -j"$(nproc)" && make install

##### FLANG #####
cd $HERE
git clone https://github.com/flang-compiler/flang.git
cd $HERE/flang/runtime/libpgmath
mkdir -p build && cd build
$INSTALL_PREFIX/bin/cmake $CMAKE_OPTIONS ..
make -j"$(nproc)" && make install
cd $HERE/flang
mkdir -p build && cd build
$INSTALL_PREFIX/bin/cmake $CMAKE_OPTIONS -DFLANG_LLVM_EXTENSIONS=ON ..
make -j"$(nproc)" && make install

cd $HERE
unset HERE
unset INSTALL_PREFIX
unset CMAKE_VER
unset CMAKE_OPTIONS
