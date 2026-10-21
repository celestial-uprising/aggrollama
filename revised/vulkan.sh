#!/usr/bin/env bash

echo "===  {START} Vulkan  ==="

set -e

export AGGRO="-march=native -mtune=znver3 -Ofast -funroll-loops -ftree-vectorize -mprefer-vector-width=256 -fomit-frame-pointer -fstrict-aliasing -stdlib=libc++ -fno-finite-math-only -Wno-pass-failed"
export OMP_PROC_BIND=TRUE

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
  -DCMAKE_EXE_LINKER_FLAGS="-s -lmimalloc -stdlib=libc++ -Wl,--allow-multiple-definition" \
  -DCMAKE_SHARED_LINKER_FLAGS="-s -lmimalloc -stdlib=libc++ -Wl,--allow-multiple-definition" \
  -DCMAKE_MODULE_LINKER_FLAGS="-s -lmimalloc -stdlib=libc++ -Wl,--allow-multiple-definition" \
  -DGGML_MIMALLOC=ON \
  -DCMAKE_INSTALL_RPATH="\$ORIGIN" \
  -DGGML_BACKEND_DL=OFF \
  -DGGML_VULKAN=ON

ninja -C build

echo "===  {END} Vulkan  ==="
