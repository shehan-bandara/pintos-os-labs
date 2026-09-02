FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    automake \
    git \
    libncurses5-dev \
    texinfo \
    perl \
    qemu \
    gdb \
    cgdb \
    ctags \
    cscope \
    python \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
