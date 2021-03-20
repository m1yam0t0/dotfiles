#!/usr/bin/env zsh

# load environment variables from zshenv
source ${HOME}/.zshenv

# list of directories
CACHE_DIRS="zsh"
DATA_DIRS="tig zsh"

# create cache directories
for d in ${CACHE_DIRS}
do
    mkdir -p ${XDG_CACHE_HOME}/$d
done

# create data directories
for d in ${DATA_DIRS}
do
    mkdir -p ${XDG_DATA_HOME}/$d
done
