# for profiling
#zmodload zsh/zprof && zprof

# LANG
export LANG=en_US.UTF-8

# XDG Base Dirctory
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share

# asdf dirctory
export ASDF_DIR="${XDG_CACHE_HOME}/asdf"
export ASDF_DATA_DIR="${ASDF_DIR}"
export ASDF_USER_SHIMS="${ASDF_DATA_DIR}/shims"
