# asdf
ASDF_DIR="${HOME}/.asdf"
if [ -d "${ASDF_DIR}" ]; then
    source ${ASDF_DIR}/asdf.sh
    fpath=(${ASDF_DIR}/completions $fpath)
fi

# source *.zsh
for rc in $(ls ${ZDOTDIR}/*.zsh);
do
    source $rc
done

# Local Settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# for profiling
#if (which zprof > /dev/null 2>&1) ;then
#    zprof
#fi
