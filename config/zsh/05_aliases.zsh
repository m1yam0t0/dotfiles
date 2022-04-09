#-----------------------------------------------------------
# general
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
alias ll='ls -laF'

# history
alias h='history -E 1'

# add -i option
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# add -p option
alias mkdir='mkdir -p'

# vim
alias vi='nvim'

# git
alias g='git'

# docker
alias d='docker'

# kubernetes
alias k='kubectl'

# dotfiles
alias dot='${HOME}/.dotfiles'
alias va='vi ${AQUA_GLOBAL_CONFIG}'
alias vv='vi ${XDG_CONFIG_HOME}/nvim/init.vim'
alias vz='vi +Files ${XDG_CONFIG_HOME}/zsh'

# shell
alias reload='exec $SHELL -l'
alias bench='for i in {1..10} ; do time ( zsh -i -c exit ); done'

#-----------------------------------------------------------
# global
#-----------------------------------------------------------
alias -g C='|wc -l' # count
alias -g G='|ag' # grep(ag)
alias -g L='|less' # less

#-----------------------------------------------------------
# suffix
#-----------------------------------------------------------
alias -s gz='tar -xzvf' # gz
alias -s py='python3' # python
