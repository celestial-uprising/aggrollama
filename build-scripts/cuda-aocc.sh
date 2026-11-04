#!/usr/bin/env bash

echo "===  {START} CUDA MAX AggroLlama Build Script  ==="

set -e

export AGGRO="-march=znver3 -O3 -Ofast -flto=full -zopt -fno-finite-math-only -fno-semantic-interposition -falign-functions=32 -fvectorize -mprefer-vector-width=256 -fomit-frame-pointer -fstrict-aliasing -Wno-pass-failed -mllvm -enable-strided-vectorization"

export OMP_PROC_BIND=spread
export OMP_WAIT_POLICY=active

cd "$HOME/src/llama-cuda/"
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
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES="60-real;86-real" \
  -DGGML_CUDA_FA_QUANTS="all" \
  -DGGML_CUDA_FORCE_MMQ=ON \
  -DGGML_BLAS=ON \
  -DGGML_BLAS_VENDOR=OpenBLAS \
  -DGGML_OPENMP=ON

ninja -C build

echo "===  {END} CUDA MAX AggroLlama Build Script  ==="
