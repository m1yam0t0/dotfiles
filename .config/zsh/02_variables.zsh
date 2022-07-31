#-----------------------------------------------------------
# General
#-----------------------------------------------------------
# terminal color
export TERM='xterm-256color'

# history
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

#-----------------------------------------------------------
# Plugins
#-----------------------------------------------------------
# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
