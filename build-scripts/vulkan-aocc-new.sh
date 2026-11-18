#!/usr/bin/env bash

echo "===  {START} Vulkan AggroLlama Build Script  ==="

set -e

export AGGRO="-march=native -zopt -O3 -ffast-math -flto=full -fremap-arrays -fvector-transform -fopenmp -ffast-math -freciprocal-math -fno-finite-math-only -fno-semantic-interposition -falign-functions=32 -fvectorize -mprefer-vector-width=256 -fomit-frame-pointer -fstrict-aliasing -Wno-pass-failed -mllvm -enable-strided-vectorization -mllvm -global-vectorize-slp=true -fepilog-vectorization-of-inductions -fenable-restrict-based-lv -mllvm -enable-conditional-fixed-value -mllvm -enable-partial-unswitch -mllvm -aggressive-loop-unswitch -mllvm -unswitch-identical-branches-min-count=3 -mllvm -lv-function-specialization -mllvm -enable-loop-fusion -mllvm -enable-loopinterchange -mllvm -fuse-tile-inner-loop -mllvm -enable-loop-distribute-adv -flto -fstrip-mining -Wl,-mllvm -Wl,-ldist-scalar-expand -ffunction-specialization-cost-model -mllvm -enable-X86-prefetching -mllvm -suppress-fmas -fnt-store=aggressive -Wl,-plugin-opt=-enable-redundant-movs -mllvm -merge-constant -mllvm -optimize-strided-mem-cost -fenable-aggressive-gather -mllvm -enable-licm-vrp -mllvm -do-block-reorder=complex -Wl,-mllvm -Wl,-do-block-reorder=complex -flto -fitodcalls -flto -fitodcallsbyclone -mllvm -function-specialize -favoid-fpe-causing-opt"

export OMP_PROC_BIND=spread
export OMP_WAIT_POLICY=active

cd "$HOME/src/llama-vulkan/"
rm -rf build

git fetch --all
git fetch --tags --all
git reset --hard origin/master || git reset --hard
git pull

cmake -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="clang" \
  -DCMAKE_CXX_COMPILER="clang++" \
  -DCMAKE_C_FLAGS="$AGGRO" \
  -DCMAKE_CXX_FLAGS="$AGGRO" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DGGML_NATIVE=ON \
  -DGGML_LTO=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-flto=full -fuse-ld=lld -Wl,-mllvm,-threads=$(nproc)" \
  -DGGML_MIMALLOC=ON \
  -DCMAKE_INSTALL_RPATH="\$ORIGIN" \
  -DGGML_BACKEND_DL=OFF \
  -DGGML_VULKAN=ON \
  -DGGML_BLAS=ON \
  -DGGML_BLAS_VENDOR=OpenBLAS \
  -DGGML_OPENMP=ON

ninja -C build

echo "===  {START} Vulkan AggroLlama Build Script  ==="
