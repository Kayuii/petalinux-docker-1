FROM ubuntu:18.04

MAINTAINER z4yx <z4yx@users.noreply.github.com>

# build with: docker build --build-arg PETA_VERSION=2019.2 --build-arg PETA_RUN_FILE=petalinux-v2019.2-final-installer.run -t petalinux:2019.2 .
#install dependences:
RUN sed -i.bak s/archive.ubuntu.com/mirror.dotsrc.org/g /etc/apt/sources.list && \
  dpkg --add-architecture i386 && apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

RUN apt-get install -y \
  build-essential \
  gcc \
  sudo \
  make \
  tofrodos \
  iproute2 \
  gawk \
  net-tools \
  expect \
  libncurses5-dev \
  tftpd \
  libssl-dev \
  flex \
  bison \
  libselinux1 \
  gnupg \
  wget \
  socat \
  gcc-multilib \
  libsdl1.2-dev \
  libglib2.0-dev \
  lib32z1-dev \
  zlib1g:i386 \
  zlib1g-dev \
  libgtk2.0-0 \
  screen \
  dialog \
  pax \
  diffstat \
  xvfb \
  xterm \
  konsole \
  nano \
  texinfo \
  gzip \
  unzip \
  tar \
  cpio \
  chrpath \
  autoconf \
  lsb-release \
  libtool \
  libtool-bin \
  locales \
  git \
  python \
  rsync

ARG PETA_VERSION
ARG PETA_RUN_FILE

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY ./keyboard /etc/default/keyboard

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado && \
  usermod -aG sudo vivado && \
  echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY accept-eula.sh ${PETA_RUN_FILE} /

# run the install
RUN chmod a+x /${PETA_RUN_FILE} && \
  mkdir -p /opt/Xilinx && \
  chmod 777 /tmp /opt/Xilinx && \
  cd /tmp && \
  sudo -u vivado /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
  rm -f /${PETA_RUN_FILE} /accept-eula.sh

USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
RUN mkdir /home/vivado/project
WORKDIR /home/vivado/project

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/vivado/.bashrc

RUN sudo apt update && sudo apt -y upgrade
