# Good News, Everyone!

  *Scripts have been further optimized!*

  *The rabbits have returned!!!*

  Benchmark result coming soon

   - early testing shows +19% token generation & +10% prompt processing *CUDA*

  (complete test results for multiple models/builds/systems will live within their own *Benchmarks* wiki...)

  This repo is considered a 'skunk-works' style development & testing trunk, while *Bartledan* [https://github.com/celestial-uprising/bartledan] will be the release branch. Detailed instructions, Containerfiles, the AOCC tarball fragments, and all verified build scripts for both AOCC & Clang. Soon, pre-built *batteries-included* container images will be available via **ghcr.io**.

  In addition to standard **llama.cpp** source, testing will also be performed against **ik_llama** and **beellama** sources

   - *BEELLAMA* initial compilation successful
   - *IK_LLAMA* failing compilation tests

   *AOCL-BLAS* is scheduled to be tested (and added to the repo and Containerfiles) in the next few days


   **Est.** update/transition period for both repos: *10/22 - 10/29*
### AggroLlama

The Llama you love; built with aggression rarely seen in polite society, but often present in the dreams of closeted, authoritarian government officials.

</div>

#### Backends & Optimizations

Build + Testing: **PASSING** 

  - *VULKAN* --- AOCC, OpenBLAS, OpenMP, Mimalloc, LTO, $AGGRO Optimizations

  - *CUDA* --- AOCC, OpenBLAS, OpenMP, Mimalloc, LTO, $AGGRO Optimizations

Build: **PASSING** + Testing: **FAILING** 

  - *ROCm* --- AOCC, Mimalloc, LTO, $AGGRO Optimizations (OpenBLAS & OpenMP, to be added as soon as ROCm testing is resumed)

Build: **FAILING** + Testing: *N/A* 

  - *ZenDNN* --- AOCC, OpenMP, Mimalloc, LTO, $AGGRO Optimizations
       *To be built against: CUDA, Vulkan & ROCm*

$AGGRO Optimizations: *-march=znver3 -O3 -Ofast -flto=full -zopt -fno-finite-math-only* 
                      *-fno-semantic-interposition -falign-functions=32 -fvectorize*
                      *-mprefer-vector-width=256 -fomit-frame-pointer -fstrict-aliasing*
                      *-Wno-pass-failed -mllvm -enable-strided-vectorization*

</div>

#### Tools

All identical to the original. (Just with a bit more spice!)

</div>


#### Contributing

It is greatly preferred; out of unabashed preservation of the emotional and spiritual faculties of my last remaining brain cell:  PR's (of actual benefit to Llama.cpp itself) go to the original project; Please and thank you!

Do not, **under any circumstances**, bring issues with the *build scripts* in this repo to the original Llama.cpp repo; as they are not (to my knowledge) considered relevant as they have been built in a non-standard, (i can only assume, unsupported) manner.

Do feel free to issue PR's with this repo, if they are related to the build process itself, the related Brontiall and Bartledan Containerfiles,.. (really- anything with bits of cabbage left on it). I will do the best a rabbit can do to assist.

### Acknowledgements

To my wife: the love of my life- my savior and queen; who has provided all the carrots, hay, and cabbage a bunny could fit in her shnozz.

*Thank you, Ma'am!*
