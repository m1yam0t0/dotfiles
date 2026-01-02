autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ":completion:*:commands" rehash 1
zstyle ':completion:*:default' menu select=2

autoload colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

lazy_load() {
    local cmd=$1
    local load_cmd=$2

    eval "${cmd}() {
        unset -f ${cmd}
        source <(eval \"${load_cmd}\")
        command ${cmd} \"\$@\"
    }"

    eval "_lazy_load_${cmd}() {
        unset -f ${cmd}
        source <(eval "${load_cmd}")
        if (( $+functions[_${cmd}] )); then
            _main_complete \"\$@\"
        fi
    }"
    compdef _lazy_load_${cmd} ${cmd}
}

lazy_load chezmoi "chezmoi completion zsh"
lazy_load kubectl "kubectl completion zsh"
lazy_load gh "gh completion -s zsh"
lazy_load mise "mise completion zsh"

