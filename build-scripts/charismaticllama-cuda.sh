#!/usr/bin/env bash
set -euo pipefail

ZENDNN_ROOT="${ZENDNN_ROOT:-$HOME/ada/llama/ZenDNN/build/install}"
REPO_DIR="${REPO_DIR:-$HOME/ada/llama/llama-zen}"

echo "===  {START}  CharismaticLlama  ==="

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
-mllvm -unroll-threshold=100 -mllvm -unroll-aggressive -funroll-loops \
-fitodcalls -fitodcallsbyclone \
-fstruct-layout=5 -mllvm -reduce-array-computations=3 \
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
-Wl,-mllvm,-lsr-in-nested-loop \
-Wl,-mllvm,-do-block-reorder=complex \
-Wl,-mllvm,-align-all-nofallthru-blocks=6 \
-Wl,-plugin-opt=-enable-redundant-movs \
-lamdlibm -lm"

cd "$REPO_DIR"
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
  -DCMAKE_CUDA_FLAGS='-O3 --use_fast_math --extra-device-vectorization -Xptxas=-O3 -Xcompiler="-march=native,-O3"' \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DCMAKE_INSTALL_RPATH='$ORIGIN' \
  -DGGML_NATIVE=ON \
  -DGGML_LTO=OFF \
  -DGGML_MIMALLOC=ON \
  -DGGML_BACKEND_DL=OFF \
  -DGGML_OPENMP=ON \
  -DGGML_BLAS=OFF \
  -DGGML_ZENDNN=ON \
  -DZENDNN_ROOT="$ZENDNN_ROOT" \
  -DGGML_CUDA=ON \
  -DCMAKE_CUDA_ARCHITECTURES="60-real;86-real" \
  -DGGML_CUDA_FA_QUANTS="f16-f16;q8_0-q8_0;q5_1-q5_1;q4_1-q4_1;q8_0-q5_1;q8_0-q4_1;q4_0-q4_0;q8_0-q4_0" \
  -DGGML_CUDA_F16=ON \
  -DGGML_CUDA_GRAPHS=ON \
  -DGGML_CUDA_FORCE_MMQ=OFF \
  -DGGML_CUDA_DMMV_X=64 \
  -DGGML_CUDA_MMV_Y=2
ninja -C build

echo "===  {END}  CharismaticLlama  ==="
echo "Tip: A/B test GGML_CUDA_DMMV_X=64 / MMV_Y=2 against defaults (32 / 1) in llama-bench."
