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

# history
alias h='history -E 1'

# rm, cp, mv add -i option
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# mkdir add -p option
alias mkdir='mkdir -p'

# grep color auto
alias grep='grep --color=auto'

# vim
alias vi='nvim'
alias vz='vi ${XDG_CONFIG_HOME}/zsh'
alias vv='vi ${XDG_CONFIG_HOME}/nvim/init.vim'

# git
alias git='hub'

