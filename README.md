# AggroLlama

## Description

The Llama you love; built with aggression rarely seen in polite society, and but often present in the dreams of closeted and authoritarian government officials.

</div>

## Quick start

 1)     clone the repo and pull the container image

 2)     run ./BE_AGGRESSIVE to run/enter the container 

 3)     fresh clone of this repo will be located in $HOME of the container's USER aggro

 4)     fresh clone of upstream llama.cpp repo will be located within aggrollama dir inside of container

 5)     run script for selected backend/lto config; completed binaries will be located in $HOME/aggrollama/llama.cpp/build/bin

</div>

## Compiler Optimizations

[AOCC - AMD Optimized C Compiler]:

[Llama.cpp]:

## Documentation

#### Tools

All identical to the original. (Just with a bit more spice!)

</div>

#### Development

## Contributing

It is greatly preferred; out of unabashed preservation of the emotional and spiritual faculties of my last remaining brain cell:  PR's (of actual benefit to Llama.cpp itself) go to the original project; Please and thank you!

Do not, under any circumstances, bring issues with the containers, binaries, or build scripts in this repo to the original repo; as they are not (to my knowledge) considered relevant as they have been built in a non-standard, (i can only assume, unsupported) manner.

Do feel free to issue PR's with this repo, if they are related to the (soon-to-be) released binaries, the build process itself, prebuilt container image,.. (anything with bits of cabbage left on it). I will do the best a rabbit can do to assist.

## Acknowledgements

See the original repo for alternative build instructions: [Original Llama.cpp Repo]{<https://github.com/ggml-org/llama.cpp}>

- [ggml-org/llama.cpp]{<https://github.com/ggml-org/llama.cpp}> - LLM inference engine written in C and C++
- [yhirose/cpp-httplib](https://github.com/yhirose/cpp-httplib) - Single-header HTTP server, used by `llama-server` - MIT license
- [nothings/stb](https://github.com/nothings/stb) - Single-header image format decoder, used by multimodal subsystem - Public domain
- [nlohmann/json](https://github.com/nlohmann/json) - Single-header JSON library, used by various tools/examples - MIT License
- [mackron/miniaudio](https://github.com/mackron/miniaudio) - Single-header audio format decoder, used by multimodal subsystem - Public domain
- [sheredom/subprocess.h](https://github.com/sheredom/subprocess.h) - Single-header process launching solution for C and C++ - Public domain
