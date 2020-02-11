# for profiling
#zmodload zsh/zprof && zprof

# LANG
export LANG=ja_JP.UTF-8

# XDG Base Dirctory
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

# anyenv
export GOENV_DISABLE_GOPATH=1
export GOPATH=~/go

# PATH
export PATH="${GOPATH}/bin:${PATH}"
