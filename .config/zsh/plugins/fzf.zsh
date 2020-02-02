# environment for fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_COMPLETION_TRIGGER=","

# history
_fzf-history() {
  BUFFER=$( fc -l 1 | fzf +m +s --tac | sed 's/ *[0-9]* *//' )
  CURSOL=$#BUFFER

  zle reset-prompt
}
zle -N _fzf-history
bindkey '^r' _fzf-history

# cd ghq list
_fzf-ghq() {
  local selected
  selected=$( ghq list | fzf +m )

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
  selected=$( git branch --all | grep -v HEAD | fzf +m | sed "s/.* //" | sed "s#remotes/[^/]*/##" )

  if [ -n "${selected}" ]; then
    git switch ${selected}
  fi
}

# kill process
_fzf-kill() {
  local pid
  pid=$( ps -ef | sed 1d | fzf -m | awk '{print $2}' )

  if [ -n "${pid}" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}

