# set zinit environment variables
typeset -A ZINIT
ZINIT_HOME=$XDG_CACHE_HOME/zinit
ZINIT[HOME_DIR]=$ZINIT_HOME
ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

# init zinit
source ${ZINIT_HOME}/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# load plugings
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

zinit ice pick"kube-ps1.sh"
zinit light jonmosco/kube-ps1

zinit ice compile"(pure|async).zsh" pick"async.zsh" src"pure.zsh"
zinit light "sindresorhus/pure"

zinit ice from"gh-r" as"program"
zinit load "junegunn/fzf-bin"

zinit ice pick"bin/op-tool" as"program"
zinit light "m1yam0t0/op-tool"

# if you already installed coreutils, load dircolors-solarized
if type gdircolors > /dev/null 2>&1; then
    # dircolor file name
    DIRCOLOR_SOLARIZED_FILE='dircolors-solarized.zsh'

    # create LS_COLORS settings & load plugin
    zinit ice atclone"gdircolors dircolors.256dark > ${DIRCOLOR_SOLARIZED_FILE}" \
        atpull"%atclone" \
        pick"${DIRCOLOR_SOLARIZED_FILE}" \
        nocompile"!"
    zinit light "seebi/dircolors-solarized"
fi
