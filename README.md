## *The Llama you love; built with aggression rarely seen in polite society, but often present in the dreams of closeted, authoritarian government officials*

### *Usage*

Distrobox compatible container images; for building AggroLlama & AggroWhisper with Clang or AOCC (*AMD's Optimized C Compiler*).

<details>
    <summary>**AOCC Infused Container Images**</summary>

    - *Vulkan* -- (*about 2.04GiB*)
    ```
    IMAGE="ghcr.io/celestial-uprising/brontitall:latest"

    distrobox create -n brontitall -i ${IMAGE}

    distrobox enter brontitall 
    ```

    - *CUDA* -- (*about 10.4GiB*)
    ```
    IMAGE="ghcr.io/celestial-uprising/brequinda:latest"

    distrobox create --nvidia -n brequinda -i ${IMAGE}

    distrobox enter brequinda
    ```
</details>

<details>
    <summary>**Clang Infused Container Images**</summary>

    - *Vulkan* -- (*about *)
    ```
    IMAGE="ghcr.io/celestial-uprising/bartledan:latest"

    distrobox create -n bartledan -i ${IMAGE}

    distrobox enter bartledan
    ```

    - *CUDA* -- (*about *)
    ```
    IMAGE="ghcr.io/celestial-uprising/bethselamin:latest"

    distrobox create --nvidia -n bethselamin -i ${IMAGE}

    distrobox enter bethselamin
    ```
</details>

### *Tools*

All identical to the originals. (Just with a bit more spice!)

</div>

  *Whisper.cpp scripts successful!!!*

  *AggroLlama Benchmarks Coming Soon!!!*

   - testing shows solid +19% token generation & +23% prompt processing *CUDA*

  (complete test results for multiple models/builds/systems will live within their own *Benchmarks* wiki...)

   *AOCL-BLAS is scheduled to be tested before long,..*

### The Llama you love; built with aggression rarely seen in polite society, but often present in the dreams of closeted, authoritarian government officials.

</div>

#### Backends & Optimizations

Build + Testing: **PASSING** 

  - *VULKAN* --- AOCC, OpenBLAS, OpenMP, Mimalloc, LTO, $AGGRO Optimizations

  - *CUDA* --- AOCC, OpenBLAS, OpenMP, Mimalloc, LTO, $AGGRO Optimizations

Build: **PASSING** + Testing: **FAILING** 

  - *BEELLAMA* initial compilation successful
  
  - *ROCm* --- AOCC, Mimalloc, LTO, $AGGRO Optimizations (OpenBLAS & OpenMP, to be added as soon as ROCm testing is resumed)

Build: **FAILING** + Testing: *N/A* 

  - *IK_LLAMA* failing compilation tests

  - *ZenDNN* --- AOCC, OpenMP, Mimalloc, LTO, $AGGRO Optimizations
       *To be built against: CUDA, Vulkan & ROCm*

$AGGRO Optimizations: *-march=znver3 -O3 -Ofast -flto=full -zopt -fno-finite-math-only* 
                      *-fno-semantic-interposition -falign-functions=32 -fvectorize*
                      *-mprefer-vector-width=256 -fomit-frame-pointer -fstrict-aliasing*
                      *-Wno-pass-failed -mllvm -enable-strided-vectorization*

</div>
</div>


#### Contributing

It is greatly preferred; out of unabashed preservation of the emotional and spiritual faculties of my last remaining brain cell:  PR's (of actual benefit to Llama.cpp itself) go to the original project; Please and thank you!

Do not, **under any circumstances**, bring issues with the *build scripts* in this repo to the original Llama.cpp repo; as they are not (to my knowledge) considered relevant as they have been built in a non-standard, (i can only assume, unsupported) manner.

Do feel free to issue PR's with this repo, if they are related to the build process itself, the related Brontiall and Bartledan Containerfiles,.. (really- anything with bits of cabbage left on it). I will do the best a rabbit can do to assist.

### Acknowledgements

To my wife: the love of my life- my savior and queen; who has provided all the carrots, hay, and cabbage a bunny could fit in her shnozz.

*Thank you, Ma'am!*
