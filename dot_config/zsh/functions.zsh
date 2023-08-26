#-----------------------------------------------------------
# hook functions
#-----------------------------------------------------------
autoload -Uz add-zsh-hook

# precmd
_precmd_tabtitle() {
    print -Pn "\e]1;${PWD##*/}\a"
}
add-zsh-hook precmd _precmd_tabtitle

# preexec
_preexec_tabtitle() {
    local cmd="${1%% *}"
    print -Pn "\e]1;${cmd} | ${PWD##*/}\a"
}
add-zsh-hook preexec _preexec_tabtitle

# chpwd
_chpwd_ls() {
    exa --color=always
}
add-zsh-hook chpwd _chpwd_ls

#-----------------------------------------------------------
# fzf functions
#-----------------------------------------------------------
# history
_fzf-history() {
    BUFFER=$(fc -l 1 | fzf +m +s --tac | sed 's/ *[0-9]* *//')
    CURSOL=$#BUFFER

    zle reset-prompt
}
zle -N _fzf-history
bindkey '^r' _fzf-history

# cd ghq list
_fzf-ghq() {
    local selected
    selected=$(ghq list | fzf +m)

    if [ -n "${selected}" ]; then
        BUFFER="cd $(ghq root)/${selected}"
        zle accept-line
    fi

    zle reset-prompt
}
zle -N _fzf-ghq
bindkey '^g' _fzf-ghq

# git switch
_fzf-git-switch() {
    local selected
    selected=$(git branch --all | grep -v HEAD | fzf +m | sed "s/.* //" | sed "s#remotes/[^/]*/##")

    if [ -n "${selected}" ]; then
        git switch ${selected}
    fi
}
