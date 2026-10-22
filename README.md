### AggroLlama

The Llama you love; built with aggression rarely seen in polite society, but often present in the dreams of closeted, authoritarian government officials.

</div>

#### Backends & Optimizations

Build + Testing: **PASSING** 

  - *VULKAN* --- AOCC, OpenMP, Mimalloc, LTO, $AGGRO Optimizations

  - *CUDA* --- AOCC, OpenMP, Mimalloc, LTO, $AGGRO Optimizations

Build: **PASSING** + Testing: **FAILING** 

  - *ROCm* --- AOCC, Mimalloc, LTO, $AGGRO Optimizations (OpenMP to be added as soon as ROCm testing is resumed)

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
