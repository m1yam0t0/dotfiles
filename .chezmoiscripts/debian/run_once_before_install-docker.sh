#!/usr/bin/env bash

# install docker
# https://docs.docker.com/engine/install/ubuntu/

# uninstall all conflicting packages
sudo apt remove -y \
    docker.io \
    docker-doc \
    docker-compose \
    podman-docker \
    containerd \
    runc

# install packages to allow apt to use a repository over HTTPS
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(grep VERSION_CODENAME /etc/os-release | awk -F'=' '{print $2}') stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Install Docker Engine, containerd, and Docker Compose.
sudo apt update
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Add current user into docker group
# shellcheck disable=SC2086
sudo usermod -aG docker $USER
