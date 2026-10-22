#!/usr/bin/env bash

echo "===  {START}  ==="

set -e

export AGGRO="-march=znver3 -O3 -Ofast -flto=full -fno-semantic-interposition -falign-functions=32 -funroll-loops -ftree-vectorize -mprefer-vector-width=256 -fomit-frame-pointer -fstrict-aliasing -Wno-pass-failed"
export OMP_PROC_BIND=TRUE

cd "$HOME/bella/llama-rocm"
rm -rf build

git fetch --all
git fetch --tags --all
git reset --hard origin/master || git reset --hard
git pull

export GPU_TARGETS="gfx90c"

cmake -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="clang" \
  -DCMAKE_CXX_COMPILER="clang++" \
  -DCMAKE_C_FLAGS="$AGGRO" \
  -DCMAKE_CXX_FLAGS="$AGGRO" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DGGML_NATIVE=ON \
  -DGGML_LTO=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-flto=full -O3 -lmimalloc -Wl,--allow-multiple-definition" \
  -DCMAKE_SHARED_LINKER_FLAGS="-flto=full -O3 -lmimalloc -Wl,--allow-multiple-definition" \
  -DCMAKE_MODULE_LINKER_FLAGS="-flto=full -O3 -lmimalloc -Wl,--allow-multiple-definition" \
  -DGGML_MIMALLOC=ON \
  -DCMAKE_INSTALL_RPATH="\$ORIGIN" \
  -DGGML_BACKEND_DL=OFF \
  -DGGML_HIP=ON \
  -DGPU_TARGETS="$GPU_TARGETS" \
  -DHIPCXX="$(hipconfig -l)/clang" \
  -DHIP_PATH="$ROCM_PATH"

ninja -C build

echo "===  {END}  ==="
