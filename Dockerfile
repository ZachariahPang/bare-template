FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

ARG USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && usermod -a -G video user \ 
  && apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

RUN sudo apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    unzip \
    git \
    unzip \
    libx11-6 \
    git-lfs \
    vim \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace
USER $USERNAME

SHELL ["/bin/bash", "-c"]

RUN curl -sSL https://install.python-poetry.org | python3 -
