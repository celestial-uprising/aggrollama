# Use an Arch Linux base image
FROM quay.io/toolbx/arch-toolbox:latest

# 1. Install System Toolchain, Matrix Backends, Dev Tools & Diagnostics
RUN pacman -Syu --noconfirm && pacman -S --noconfirm \
    base-devel \
    cmake \
    git \
    curl \
    wget \
    ca-certificates \
    pciutils \
    pkgconf \
    python \
    python-pip \
    clang \
    ninja \
    btop \
    nvtop \
    radeontop \
    s-tui \
    lm_sensors \
    libdrm \
    openssl \
    spirv-headers \
    shaderc \
    openblas \
    vulkan-devel \
    vulkan-tools \
    glslang \
    clblast \
    sudo \
    rustup \
    vim \
    tmux \
    mimalloc \
    openmp \
    neovim && \
    pacman -Scc --noconfirm

# Configure system locale for Arch
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# 2. Install NVIDIA CUDA Toolkit
RUN pacman -S --noconfirm cuda && pacman -Scc --noconfirm

# 3. Install AMD ROCm / HIP Compilation Stack
RUN pacman -S --noconfirm \
    hip-runtime-amd \
    hipblas \
    rocblas \
    rocminfo \
    && pacman -Scc --noconfirm

# 4. Install AMD AOCC Compiler Suite from the AUR (Using Pre-downloaded Source Tarball)
# AUR builds must run as a non-root user with passwordless sudo access
RUN useradd -m -G wheel aur-builder && \
    echo "aur-builder ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/aur-builder && \
    chmod 0440 /etc/sudoers.d/aur-builder

USER aur-builder
WORKDIR /tmp

# Clone the aocc AUR repository metadata first
RUN git clone https://aur.archlinux.org/aocc.git

# Copy your pre-downloaded upstream AMD tarball archive directly into the cloned AUR folder.
# NOTE: Ensure the local file name strictly matches the filename the AUR's PKGBUILD expects.
# (e.g., 'aocc-compiler-5.2.0.tar.gz' or similar versioned archive)
COPY --chown=aur-builder:aur-builder aocc-compiler-5.2.0.tar /tmp/aocc/

# Run the build. makepkg will detect the file in place and bypass the network download step.
RUN cd aocc && \
    makepkg -si --noconfirm && \
    cd /tmp && \
    rm -rf aocc

# Revert to root user to finish system administration tasks
USER root
WORKDIR /
RUN userdel -r aur-builder && rm -f /etc/sudoers.d/aur-builder

# 5. Establish Non-Root Environment with 'aggro' User in wheel and render Groups
RUN groupadd -f render && \
    useradd -m -s /bin/bash -G wheel,render aggro && \
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
    git clone https://github.com/LazyVim/starter ~/.config/nvim && \
    rm -rf ~/.config/nvim/.git

# 9. Register Toolchain Environment Search Paths
# Note: The standard AUR 'aocc' package symlinks or paths typically map to the explicit version installed.
# If the AUR package updates the path format, ensure this matches the /opt/AMD directory structure.
ENV PATH="/opt/AMD/aocc-compiler-5.2.0/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/AMD/aocc-compiler-5.2.0/lib:/opt/cuda/lib64:${LD_LIBRARY_PATH}"

WORKDIR /home/aggro
CMD ["/bin/bash"]

