FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

# USER Setup
ARG USER=robesafe
ARG UID=1000
ARG GID=1000

## Install essential packages 
RUN apt update && DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
    apt-utils \
    build-essential \
    git \
    vim \
    tree \
    ca-certificates \
    libjpeg-dev \
    libpng16-16 \
    libtiff5 \
    libpng-dev \
    libyaml-cpp-dev \
    lsb-core \
    python3-dev \
    python-is-python3 \
    python3-setuptools \
    python3-pip \
    qtbase5-dev && \ 
    pip3 install --upgrade pip && \
    rm -rf /var/lib/apt/lists/*

## Add USER
RUN useradd -m ${USER} -u ${UID}
WORKDIR /home/${USER}/workspace/

## Install Python libraries
ADD --chown=${UID}:${GID} requirements.txt /home/${USER}/workspace/requirements.txt
RUN python3 -m pip install --upgrade pip
RUN pip3 install -r requirements.txt
RUN pip3 install nvidia-tensorrt==8.4.3.1

## Remove aux_files
WORKDIR /home/${USER}/workspace/
RUN rm -rf requirements.txt

# Change terminal colors
RUN echo "# Change terminal colors \n\
PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc

# Execute bashrc
CMD ["/bin/bash"]