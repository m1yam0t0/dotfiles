#-----------------------------------------------------------
# General
#-----------------------------------------------------------
## LANG
# set UTF-8
export LANG=ja_JP.UTF-8

# set LANG=C to root user
case ${UID} in
    0)
        LANG=C
        ;;
esac

# XDG Base Dirctory
export XDG_CACHE_HOME=~/.cache
export XDG_CONFIG_HOME=~/.config

# setopt
setopt print_eight_bit
setopt no_beep
setopt nolistbeep
setopt notify
setopt no_flow_control
setopt interactive_comments
setopt IGNOREEOF

# bindkey
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey "^h" backward-delete-char

# CountTime when exec time > 3s
REPORTTIME=3

#-----------------------------------------------------------
# Color
#-----------------------------------------------------------
# Enable Color
autoload -Uz colors
colors

export TERM='xterm-256color'

#-----------------------------------------------------------
# Prompt
#-----------------------------------------------------------

# Set Options
setopt prompt_subst
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# title
add-zsh-hook precmd _update_term_title
function _update_term_title() {
    pwd=$(pwd)
    cwd=${pwd##*/}
    print -Pn "\e]0;$cwd\a"
}

# vcs_info
zstyle ":vcs_info:*" enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '[38;5;136m!'
zstyle ':vcs_info:git:*' unstagedstr '[38;5;160m+'
zstyle ':vcs_info:*' formats '[38;5;40m%c%u[%b][0m'
zstyle ':vcs_info:*' actionformats '[38;5;001m%c%u[%b|%a][0m'

# update vcs_info before command
add-zsh-hook precmd _update_vcs_info_msg
function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
}

add-zsh-hook precmd _update_prompt
function _update_prompt() {
    PROMPT_FIRST_LINE="[38;5;75m[%n@%m][0m %~ ${vcs_info_msg_0_}"
    PROMPT='${PROMPT_FIRST_LINE}
%# '
}

# preexec
preexec() {
    printf "\033]0;%s\a" "${1%% *} | $cwd"
}

#-----------------------------------------------------------
# History
#-----------------------------------------------------------
# Save history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Disable history for root
if [ $UID = 0 ]; then
    unset HISTFILE
    SAVEHIST=0
fi

# setopt
setopt share_history
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

#-----------------------------------------------------------
# Completion
#-----------------------------------------------------------
# Enable compinit
autoload -Uz compinit
compinit

zstyle ':completion:*' keep-prefix
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:options' description 'yes'

# command completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# word settings
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# setopt
#setopt correct
setopt complete_in_word
setopt always_last_prompt
setopt interactive_comments
setopt list_types
setopt list_packed
setopt glob
setopt globdots
setopt glob_complete
setopt extended_glob
setopt numeric_glob_sort
setopt magic_equal_subst
setopt mark_dirs

# auto cd & pushd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

#-----------------------------------------------------------
# alias
#-----------------------------------------------------------
# ls
case ${OSTYPE} in
    darwin*)
        if type gls > /dev/null 2>&1; then
            alias ls='gls -F --group-directories-first --color=auto'
        fi
        ;;
    linux*)
        alias ls='ls -F --group-directories-first --color=auto'
        ;;
esac
alias l='ls -lah'

# history
alias h='history -E 1'

# rm, cp, mv add -i option
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# mkdir add -p option
alias mkdir='mkdir -p'

# grep color auto
alias grep='grep --color=auto'

# vim
alias vi='nvim'
alias vz='vi ~/.zshrc'
alias vv='vi ~/.vimrc'

# git
alias git='hub'

#-----------------------------------------------------------
# Function
#-----------------------------------------------------------
chpwd() {
    ls_abbrev
}

ls_abbrev() {
    if [[ ! -r $PWD ]]; then
        return
    fi

    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--group-directories-first' '--color=always')

    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')
    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

#-----------------------------------------------------------
# Plugin
#-----------------------------------------------------------
# zplug
[ -d ~/.zplug ] && source $XDG_CONFIG_HOME/zsh/zplug.zsh
# anyenv
[ -d ~/.anyenv ] && eval "$(anyenv init -)" && eval "$(pyenv virtualenv-init -)"

#-----------------------------------------------------------
# Local Settings
#-----------------------------------------------------------
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

