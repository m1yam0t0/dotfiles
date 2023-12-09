zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ":completion:*:commands" rehash 1
zstyle ':completion:*:default' menu select=2

autoload colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Lazyload
kubectl () {
  unset -f kubectl
  source <(kubectl completion zsh)
  kubectl "$@"
}
