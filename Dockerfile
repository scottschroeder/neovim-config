FROM ubuntu:latest


RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
RUN chmod u+x nvim.appimage
RUN ./nvim.appimage --appimage-extract
RUN ln -s /squashfs-root/AppRun /usr/bin/nvim
RUN ln -s /squashfs-root/AppRun /usr/bin/vim

RUN useradd -ms /bin/bash manager
USER manager
WORKDIR /home/manager
RUN mkdir -p /home/manager/.config /home/manager/.local/share/

