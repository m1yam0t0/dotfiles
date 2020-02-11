# source *.zsh
for rc in $(ls ${ZDOTDIR}/*.zsh);
do
    source $rc
done

# anyenv
[ -d ~/.anyenv ] && eval "$(anyenv init - --no-rehash)" && eval "$(pyenv virtualenv-init - )"

# Local Settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# for profiling
#if (which zprof > /dev/null 2>&1) ;then
#    zprof
#fi
