export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# history
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^R' select-history
