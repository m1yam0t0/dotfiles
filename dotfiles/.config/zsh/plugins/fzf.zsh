# environment for fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_COMPLETION_TRIGGER=","

# history
fzf-history() {
  BUFFER=$( fc -rl 1 | fzf +m --query="$LBUFFER" | sed 's/ *[0-9]* *//' )
  CURSOL=$#BUFFER

  zle reset-prompt
}
zle -N fzf-history
bindkey '^r' fzf-history

# cd ghq list
fzf-ghq() {
  local selected
  selected=$( ghq list | fzf +m --query="$LBUFFER" )

  if [ -n "$selected" ]; then
    BUFFER="cd $(ghq root)/${selected}"
    zle accept-line
  fi

  zle reset-prompt
}
zle -N fzf-ghq
bindkey '^g' fzf-ghq

# kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# git commit browser (enter for show, ctrl-d for diff)
fshow() {
  local out shas sha q k
  while out=$(
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" \
          --print-query --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}
