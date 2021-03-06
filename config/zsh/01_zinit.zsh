# set zinit environment variables
typeset -A ZINIT
ZINIT_HOME=$XDG_CACHE_HOME/zinit
ZINIT[HOME_DIR]=$ZINIT_HOME
ZINIT[ZCOMPDUMP_PATH]=$XDG_CACHE_HOME/zsh/zcompdump

# init zinit
source ${ZINIT_HOME}/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# load plugins
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

zinit ice depth=1
zinit light "romkatv/powerlevel10k"

zinit ice from"gh-r" as"program"
zinit load "junegunn/fzf-bin"

zinit ice from"gh-r" as"program" pick"**/gh"
zinit light "cli/cli"

zinit ice from"gh-r" as"program" pick"ghq_**/ghq"
zinit light "x-motemen/ghq"

zinit ice from"gh-r" as"program" pick"kustomize_**/kustomize"
zinit light "kubernetes-sigs/kustomize"

zinit ice from"gh-r" as"program" pick"stern_**/stern"
zinit light "stern/stern"

zinit ice pick"bin/op-tool" as"program"
zinit light "m1yam0t0/op-tool"

# if you already installed dircolors, load dircolors-solarized
# dircolor file name
DIRCOLOR_SOLARIZED_FILE='dircolors-solarized.zsh'

# create LS_COLORS settings & load plugin
if type dircolors > /dev/null 2>&1; then
    zinit ice atclone"dircolors dircolors.256dark > ${DIRCOLOR_SOLARIZED_FILE}" \
        atpull"%atclone" \
        pick"${DIRCOLOR_SOLARIZED_FILE}" \
        nocompile"!"
    zinit light "seebi/dircolors-solarized"
elif type gdircolors > /dev/null 2>&1; then
    zinit ice atclone"gdircolors dircolors.256dark > ${DIRCOLOR_SOLARIZED_FILE}" \
        atpull"%atclone" \
        pick"${DIRCOLOR_SOLARIZED_FILE}" \
        nocompile"!"
    zinit light "seebi/dircolors-solarized"
fi
