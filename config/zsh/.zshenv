# for profiling
#zmodload zsh/zprof && zprof

# LANG
export LANG=en_US.UTF-8

# XDG Base Dirctory
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

# aqua
export AQUA_GLOBAL_CONFIG=${XDG_CONFIG_HOME}/aquaproj-aqua/aqua.yaml
export AQUA_ROOT_DIR=${XDG_DATA_HOME}/aquaproj-aqua
export PATH=${AQUA_ROOT_DIR}/bin:$PATH
