#!/usr/bin/env bash
set -e # Exit immediately if any command fails

export AGGRO="-march=znver3 -Ofast -flto=auto -ffat-lto-objects -funroll-loops -ftree-vectorize -mprefer-vector-width=256 -fno-finite-math-only -I$HOME/.src/ZenDNN/build/install/deps/fbgemm/include -I$HOME/.src/ZenDNN/external/fbgemm/include"
export CFLAGS="-march=znver3 -O3 -ffast-math -fno-finite-math-only -ftree-vectorize -mprefer-vector-width=256"
export CXXFLAGS="-march=znver3 -O3 -ffast-math -fno-finite-math-only -ftree-vectorize -mprefer-vector-width=256"

echo "===  Building AggroZenDnn!  ==="

cd $HOME/.src/ZenDNN
rm -rf build
git fetch --all
git pull
mkdir build
cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DZENDNN_BUILD_EXAMPLES=OFF \
  -DZENDNN_BUILD_TESTS=OFF
cmake --build . --target all -j12

echo "===  Building AggroLlama!  ==="

cd $HOME/.src/llama.cpp
rm -rf build
git fetch --all
git pull
export HIPCXX="/usr/lib64/rocm/llvm/bin/clang++"
export HIP_PATH="/usr/lib64/rocm"
export HSA_OVERRIDE_GFX_VERSION=9.0.0
export ZENDNN_ROOT="$HOME/.src/ZenDNN/build/install"
cmake -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DGGML_NATIVE=ON \
  -DINTERPROCEDURAL_OPTIMIZATION=ON \
  -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-s" \
  -DCMAKE_C_FLAGS="$AGGRO" \
  -DCMAKE_CXX_FLAGS="$AGGRO" \
  -DGGML_BACKEND_DL=OFF \
  -DGGML_HIP=ON \
  -DAMDGPU_TARGETS="gfx900" \
  -DCMAKE_HIP_COMPILER_ROCM_ROOT=/usr \
  -DGGML_MIMALLOC=ON \
  -DGGML_ZENDNN=ON \
  -DZENDNN_ROOT="$ZENDNN_ROOT"
cmake --build build --config Release -j12

echo "===  Done: AggroLlama Build Completed!  ==="

