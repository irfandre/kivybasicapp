FROM ubuntu:latest
# configures locale
RUN apt-get update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq --yes --no-install-recommends \
    locales && \
    locale-gen en_US.UTF-8
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"
# system requirements to build most of the recipes
RUN apt-get update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq --yes --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ccache \ 
    cmake \
    gettext \
    git \
    libffi-dev \
    libltdl-dev \
    libssl-dev \
    libtool \
    openjdk-13-jdk \
    patch \
    pkg-config \
    python3-pip \ 
    python3-setuptools \
    sudo \ 
    unzip \
    zip \
    zlib1g-dev 

RUN apt-get update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq --yes --no-install-recommends \
    vim \
    wget

RUN apt-get update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq --yes --no-install-recommends \
    git

RUN wget https://github.com/HeaTTheatR/KivyMD-data/raw/master/install-kivy-buildozer-dependencies.sh
RUN chmod +x install-kivy-buildozer-dependencies.sh

RUN sed -i 's/sudo //g' install-kivy-buildozer-dependencies.sh 

#RUN useradd -m -d /home/kivy kivy
# prepares non root env
RUN useradd --create-home --shell /bin/bash kivy
# with sudo access and no password
RUN usermod -append --groups sudo kivy

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN pip3 install virtualenv

#USER kivy
RUN virtualenv env

RUN env/bin/pip 
RUN ./install-kivy-buildozer-dependencies.sh

# installs buildozer and dependencies
RUN pip install --user --upgrade Cython==0.29.19 wheel pip virtualenv
RUN pip install kivy

WORKDIR /home/kivy/

ADD main.py buildozer.spec /home/kivy/

CMD bash
