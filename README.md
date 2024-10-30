# An example of a devcontainer for a Python project for deep learning purposes

Idealy this should achieve a seamless dev experience and can access all GPUs and do git command without needing to manually configure things.

## Prerequisites

- Docker
- [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

Most cloud providers have these pre-installed.


## Build the container

```{bash}
docker build --build-arg USERNAME=user \
             --build-arg USER_UID=$(id -u) \
             --build-arg USER_GID=$(id -g) \
             -t dev-env .
```

- We pass in the user's UID and GID to ensure that the user has the same permissions inside and outside the container. So that the user can write to the mounted volume.

## Run the container
```{bash}
sudo docker run -it --rm \
    --gpus all \
    --ipc=host \
    -v $HOME/.gitconfig:/home/user/.gitconfig \
    -v $SSH_AUTH_SOCK:/ssh-agent \
    -e SSH_AUTH_SOCK=/ssh-agent \
    -v $(pwd):/workspace \
    -w /workspace \
    --user $(id -u):$(id -g) \
    dev-env bash
```

- `--gpus all` allows the container to access all GPUs on the host machine.
- `--ipc=host` is needed for dataloader multiprocessing.
- `-v $(pwd):/workspace` mounts the current directory to the container.
- `-v $HOME/.gitconfig:/home/user/.gitconfig` mounts the user's global Git configuration file into the container.
- `-w /workspace` sets the working directory to the mounted volume.
- `--user $(id -u):$(id -g)` sets the user inside the container to the same user as the host machine.

