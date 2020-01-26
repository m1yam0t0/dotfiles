#!/usr/bin/env bash

# install bundled docker-completion
etc=/Applications/Docker.app/Contents/Resources/etc
ln -snf $etc/docker.zsh-completion /usr/local/share/zsh/site-functions/_docker
ln -snf $etc/docker-compose.zsh-completion /usr/local/share/zsh/site-functions/_docker-compose
