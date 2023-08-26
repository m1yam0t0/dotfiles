#-----------------------------------------------------------
# General
#-----------------------------------------------------------
# terminal color
export TERM='xterm-256color'

setopt no_beep

#-----------------------------------------------------------
# History
#-----------------------------------------------------------
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt extended_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

#-----------------------------------------------------------
# Keybind
#-----------------------------------------------------------
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey '^?' backward-delete-char

#-----------------------------------------------------------
# Command Options
#-----------------------------------------------------------
# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
