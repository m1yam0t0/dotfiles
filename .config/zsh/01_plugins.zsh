# set zinit environment variables
typeset -A ZINIT
ZINIT_HOME=${XDG_DATA_HOME}/zinit/zinit.git
ZINIT[HOME_DIR]=${ZINIT_HOME}
ZINIT[ZCOMPDUMP_PATH]=${XDG_CACHE_HOME}/zsh/zcompdump

# init zinit
source ${ZINIT_HOME}/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# load plugins
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

zinit ice depth=1
zinit light "romkatv/powerlevel10k"

zinit ice pick"bin/op-tool" as"program"
zinit light "m1yam0t0/op-tool"

