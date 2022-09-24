#-----------------------------------------------------------
# general
#-----------------------------------------------------------
# shorten
alias d='docker'
alias g='git'
alias k='kubectl'

# add option
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# replace command
alias cat='bat -pp'
alias imgcat='wezterm imgcat'
alias ls='exa --color=always'
alias tree='exa -T'
alias vi='nvim'
alias watch='viddy'

# ls
alias l='exa -laghF --icons --git'
alias ll='exa -laF'

# history
alias h='history -E 1'

# dotfiles
alias reload='exec $SHELL -l'
alias bench='for i in {1..10} ; do time ( zsh -i -c exit ); done'

#-----------------------------------------------------------
# global
#-----------------------------------------------------------
alias -g C='|wc -l'     # count
alias -g G='|rg'        # grep(ripgrep)
alias -g L='|less'      # less

#-----------------------------------------------------------
# suffix
#-----------------------------------------------------------
alias -s gz='tar -xzvf' # gz
alias -s py='python3'   # python
