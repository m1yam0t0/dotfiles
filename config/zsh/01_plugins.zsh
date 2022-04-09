# set zi environment variables
typeset -A ZI
ZI_HOME=$XDG_CACHE_HOME/zi
ZI[HOME_DIR]=$ZI_HOME
ZI[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

# init zi
source ${ZI_HOME}/bin/zi.zsh
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# load plugins
zi wait lucid for \
 atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    z-shell/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

zi ice depth=1
zi light "romkatv/powerlevel10k"

zi ice pick"bin/op-tool" as"program"
zi light "m1yam0t0/op-tool"

# if you already installed dircolors, load dircolors-solarized
# dircolor file name
DIRCOLOR_SOLARIZED_FILE='dircolors-solarized.zsh'

# create LS_COLORS settings & load plugin
if type dircolors > /dev/null 2>&1; then
    zi ice atclone"dircolors dircolors.256dark > ${DIRCOLOR_SOLARIZED_FILE}" \
        atpull"%atclone" \
        pick"${DIRCOLOR_SOLARIZED_FILE}" \
        nocompile"!"
    zi light "seebi/dircolors-solarized"
elif type gdircolors > /dev/null 2>&1; then
    zi ice atclone"gdircolors dircolors.256dark > ${DIRCOLOR_SOLARIZED_FILE}" \
        atpull"%atclone" \
        pick"${DIRCOLOR_SOLARIZED_FILE}" \
        nocompile"!"
    zi light "seebi/dircolors-solarized"
fi
