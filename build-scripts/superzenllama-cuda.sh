#!/usr/bin/env bash
set -euo pipefail

echo "===  {START}  SuperZenLlama  ==="

export OMP_PROC_BIND=spread
export OMP_PLACES=cores
export OMP_WAIT_POLICY=active
export CUDA_DEVICE_ORDER=PCI_BUS_ID
export ZENDNNL_MATMUL_ALGO=1

export AGGRO_CFLAGS="\
-march=native -zopt -O3 -flto=full \
-ffast-math -fno-finite-math-only -fno-semantic-interposition \
-falign-functions=32 -falign-loops=32 -mprefer-vector-width=256 \
-fveclib=AMDLIBM \
-mllvm -inline-threshold=1000 -finline-recursion=4 \
-fitodcalls -fitodcallsbyclone \
-mllvm -global-vectorize-slp=true \
-fepilog-vectorization-of-inductions -fenable-restrict-based-lv \
-mllvm -enable-conditional-fixed-value \
-mllvm -enable-partial-unswitch -mllvm -aggressive-loop-unswitch \
-mllvm -lv-function-specialization \
-mllvm -enable-loop-fusion -mllvm -enable-loopinterchange \
-mllvm -fuse-tile-inner-loop -mllvm -enable-loop-distribute-adv \
-fstrip-mining -ffunction-specialization-cost-model \
-mllvm -enable-strided-vectorization -mllvm -optimize-strided-mem-cost \
-mllvm -enable-licm-vrp -mllvm -merge-constant \
-mllvm -do-block-reorder=complex \
-Wno-pass-failed -Wno-unused-command-line-argument -Wno-c++11-narrowing"

export AGGRO_LDFLAGS="\
-flto=full -fuse-ld=lld \
-Wl,-mllvm,-threads=$(nproc) \
-Wl,-mllvm,-extra-inliner \
-Wl,-mllvm,-ldist-scalar-expand \
-Wl,-mllvm,-do-block-reorder=complex \
-Wl,-plugin-opt=-enable-redundant-movs \
-lamdlibm -lm"

cd "$HOME/ada/llama/llama-cuda/"
rm -rf build
git fetch --all --tags
git reset --hard origin/master || git reset --hard
git pull

cmake -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_C_COMPILER="clang" \
  -DCMAKE_CXX_COMPILER="clang++" \
  -DCMAKE_C_FLAGS="$AGGRO_CFLAGS" \
  -DCMAKE_CXX_FLAGS="$AGGRO_CFLAGS" \
  -DCMAKE_EXE_LINKER_FLAGS="$AGGRO_LDFLAGS" \
  -DCMAKE_SHARED_LINKER_FLAGS="$AGGRO_LDFLAGS" \
  -DCMAKE_CUDA_FLAGS="-O3 --use_fast_math -Xptxas=-O3 -Xcompiler=\"-march=native,-O3\"" \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DCMAKE_INSTALL_RPATH="\$ORIGIN" \
  -DGGML_NATIVE=ON \
  -DGGML_LTO=OFF \
  -DGGML_MIMALLOC=ON \
  -DGGML_BACKEND_DL=OFF \
  -DGGML_OPENMP=ON \
  -DGGML_BLAS=OFF \
  -DGGML_ZENDNN=ON \
  -DZENDNN_ROOT="/home/shepherd/ada/llama/ZenDNN/build/install" \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES="60-real;86-real" \
  -DGGML_CUDA_FA_QUANTS="f16-f16;q8_0-q8_0;q5_1-q5_1;q4_1-q4_1;q8_0-q5_1;q8_0-q4_1;q4_0-q4_0;q8_0-q4_0" \
  -DGGML_CUDA_F16=ON \
  -DGGML_CUDA_GRAPHS=ON \
  -DGGML_CUDA_FORCE_MMQ=OFF
ninja -C build

echo "===  {END}  SuperZenLlama  ==="
echo "Remember to export ZENDNNL_MATMUL_ALGO=1 when running llama-server/llama-cli."
