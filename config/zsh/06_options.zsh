#-----------------------------------------------------------
# General
#-----------------------------------------------------------
autoload -Uz add-zsh-hook

setopt print_eight_bit
setopt no_beep
setopt nolistbeep
setopt notify
setopt no_flow_control
setopt interactive_comments
setopt ignoreeof

#-----------------------------------------------------------
# Color
#-----------------------------------------------------------
autoload -Uz colors
colors

#-----------------------------------------------------------
# History
#-----------------------------------------------------------
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
compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump

zstyle ':completion:*' keep-prefix
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:options' description 'yes'

# command completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
if [ -n "${LS_COLORS}" ]; then
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# word settings
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars ' /=;@:{},|'
zstyle ':zle:*' word-style unspecified

# setopt
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
# Hook
#-----------------------------------------------------------

# precmd
add-zsh-hook precmd _precmd_tabtitle

# preexec
add-zsh-hook preexec _preexec_tabtitle

# chpwd
add-zsh-hook chpwd _chpwd_ls
