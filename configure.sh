#!/bin/sh
mkdir riscv
mkdir riscv/toolchain
export RISCV=$(readlink -f riscv/toolchain)
mkdir third_party
cd third_party
git clone --depth 1 --single-branch https://github.com/riscv/riscv-opcodes
git clone --depth 1 --single-branch https://github.com/riscv-software-src/riscv-isa-sim
git clone --depth 1 --single-branch https://github.com/riscv-software-src/riscv-tests
cd riscv-tests
git submodule update --init --recursive --progress --recommend-shallow --depth 1
cd ..
git clone --depth 1 --single-branch https://github.com/riscv-collab/riscv-gnu-toolchain
cd riscv-gnu-toolchain
git submodule update --init --recursive --progress --recommend-shallow --depth 1
cd ..
git clone --depth 1 --single-branch https://github.com/riscv-software-src/riscv-pk
git clone --depth 1 --single-branch https://github.com/llvm/llvm-project
export MAKE=`command -v gmake || command -v make`
export PATH="$RISCV/bin:$PATH"
set -e
function build_project {
  export PROJECT="$1"
  shift
  if [ -e "$PROJECT/build" ]
  then
    rm -rf "$PROJECT/build"
  fi
  if [ ! -e "$PROJECT/configure" ]
  then
    (
      cd "$PROJECT"
      find . -iname configure.ac | sed s/configure.ac/m4/ | xargs mkdir -p
      autoreconf -i
    )
  fi
  mkdir -p "$PROJECT/build"
  cd "$PROJECT/build"
  ../configure $* > build.log
  $MAKE >> build.log
  $MAKE install >> build.log
  cd - > /dev/null
}
build_project riscv-isa-sim --prefix=$RISCV
cd riscv-gnu-toolchain
sed -i .bak "s/.*=host-darwin.o$//" riscv-gcc/gcc/config.host
sed -i .bak "s/.* x-darwin.$//" riscv-gcc/gcc/config.host
cd ..
build_project riscv-gnu-toolchain --prefix=$RISCV --with-cmodel=medany
cd llvm-project
mkdir build
cd build
cmake -G "Unix Makefiles" \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt;libc;libclc;libcxx;libcxxabi;libunwind;lld;lldb;openmp;polly;pstl" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$RISCV" \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-elf" \
  -DDEFAULT_SYSROOT="$RISCV/riscv64-unknown-elf" \
  -DGCC_INSTALL_PREFIX="$RISCV" \
  ../llvm
cmake --build .
cmake --build . --target install
cd ..
cd ..
cd riscv-pk
mkdir build
../configure --prefix=$RISCV --host=riscv64-unknown-elf --with-arch=rv64imafdcv
make
make install
cd ..
cd ..
