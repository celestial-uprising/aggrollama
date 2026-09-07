# Start from Ubuntu 24.04 LTS 
FROM quay.io/toolbx/ubuntu-toolbox:latest

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install System Toolchain, Matrix Backends, Dev Tools & Diagnostics
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    wget \
    ca-certificates \
    pciutils \
    pkg-config \
    python3 \
    python3-pip \
    clang \
    libclang-dev \
    ninja-build \
    btop \
    nvtop \
    radeontop \
    libdrm-dev \
    librocm-smi-dev \
    libssl-dev \
    spirv-headers \
    glslc \
    libopenblas-dev \
    libvulkan-dev \
    vulkan-tools \
    glslang-tools \
    libclblast-dev \
    sudo \
    rustup \
    vim \
    tmux \
    fzf \
    fd-find \
    ripgrep \
    zoxide \
    tree-sitter-cli \
    eza \
    bat \
    neovim \
    lazyvim \
    python3-pynvim \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# 2. Install NVIDIA CUDA Toolkit (User-space Compilers & Matrix Headers)
RUN apt-get update && apt-get install -y \
    nvidia-cuda-toolkit \
    && rm -rf /var/lib/apt/lists/*

# 3. Install AMD ROCm / HIP Compilation Stack
RUN apt-get update && apt-get install -y \
    hipcc \
    libhipblas-dev \
    librocblas-dev \
    rocminfo \
    && rm -rf /var/lib/apt/lists/*

# 4. Install AMD AOCC Compiler Suite (Version 4.2.0)
# DONE AS ROOT: This guarantees the deb package installs to /opt without permissions errors
COPY aocc-compiler-5.2.0_1_amd64.deb /tmp/aocc.deb
RUN apt-get update && \
    dpkg -i /tmp/aocc.deb || apt-get install -f -y && \
    rm -f /tmp/aocc.deb

# 5. Establish Non-Root Environment with 'aggro' User in sudo and render Groups
RUN groupadd -f render && \
    useradd -m -s /bin/bash -G sudo,render aggro && \
    echo "aggro ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/aggro && \
    chmod 0440 /etc/sudoers.d/aggro

# 6. Switch execution profile to 'aggro' user for user-space setups
USER aggro
ENV HOME=/home/aggro

# 7. Install Rust via official Rustup script for the 'aggro' User
ENV RUSTUP_HOME=${HOME}/.rustup
ENV CARGO_HOME=${HOME}/.cargo
ENV PATH="${CARGO_HOME}/bin:${PATH}"
RUN rustup default beta

# 8. Set Up Workspaces and Repository Pipelines directly in /home/aggro
RUN git clone https://github.com/celestial-uprising/aggrollama.git ${HOME}/aggrollama && \
    git clone --recursive https://github.com/ggml-org/llama.cpp.git ${HOME}/aggrollama/llama.cpp && \
    git clone https://github.com/LazyVim/starter ~/.config/nvim
RUN rm -rf ~/.config/nvim/.git

# 9. Register Toolchain Environment Search Paths 
ENV PATH="/opt/AMD/aocc-compiler-4.2.0/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/AMD/aocc-compiler-4.2.0/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"

WORKDIR /home/aggro
CMD ["/bin/bash"]

