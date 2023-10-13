#-----------------------------------------------------------
# alias
#-----------------------------------------------------------
# shorten
alias d='docker'
alias g='git'
alias k='kubectl'
alias tf='terraform'

# add option
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

# replace command
alias cat='bat -pp'
alias imgcat='wezterm imgcat'
alias ls='exa --color=always'
alias tree='exa -T'
alias vi='nvim'
alias watch='viddy'

# git
alias gl='git log --oneline origin..HEAD'
alias gs='git status --short'
alias gsw='_fzf-git-switch'

# history
alias h='history -i 1'

# ls
alias l='exa -laghF --color=always --group-directories-first --icons --git'

# dotfiles
alias bench='for i in {1..10} ; do time ( zsh -i -c exit ); done'
alias reload='exec $SHELL -l'

#-----------------------------------------------------------
# suffix
#-----------------------------------------------------------
alias -s gz='tar -xzvf' # gz
alias -s py='python3'   # python
