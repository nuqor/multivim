ARG DEBIAN_VERSION=trixie


#
# BUILDER
#

FROM debian:${DEBIAN_VERSION} AS builder

ARG NEOVIM_VERSION=0.11.3

RUN apt-get -y update && apt-get -y install \
    ninja-build \
    gettext \
    cmake \
    curl \
    build-essential \
    git

WORKDIR /tmp

RUN git clone \
    --depth 1 \
    --branch v${NEOVIM_VERSION} \
    https://github.com/neovim/neovim.git

WORKDIR /tmp/neovim

RUN cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo \
    && cmake --build .deps

RUN cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=RelWithDebInfo -D CMAKE_INSTALL_PREFIX=/tmp/out \
    && cmake --build build

RUN ninja -C build install


#
# RUNTIME
# 

FROM debian:${DEBIAN_VERSION} AS runtime
COPY --from=builder /tmp/out /usr/local

RUN apt-get -y update && apt-get -y install \
    curl \
    ruby \
    ruby-neovim \
    python3 \
    python3-pynvim \
    perl \
    ripgrep \
    nodejs \
    npm

RUN npm install -g neovim

RUN useradd \
  --create-home \
  --shell /bin/bash \
  user

RUN mkdir -p /home/user/.config/nvim

USER user
WORKDIR /home/user

ENTRYPOINT [ "/usr/local/bin/nvim" ]
