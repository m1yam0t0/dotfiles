# init zinit
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# load plugings
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/fast-syntax-highlighting

zinit ice pick"kube-ps1.sh"
zinit light "jonmosco/kube-ps1"

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zinit ice from"gh-r" as"program"
zinit load "junegunn/fzf-bin"

zinit ice pick"bin/op-tool" as"program"
zinit light m1yam0t0/op-tool

# if you already installed coreutils, load dircolors-solarized
if type gdircolors > /dev/null 2>&1; then
    # dircolor file name
    DIRCOLOR_SOLARIZED_FILE='dircolors-solarized.zsh'

    # create LS_COLORS settings & load plugin
    zinit ice atclone"gdircolors dircolors.256dark > ${DIRCOLOR_SOLARIZED_FILE}" \
        atpull'%atclone' \
        pick"${DIRCOLOR_SOLARIZED_FILE}" \
        nocompile'!'
    zinit light seebi/dircolors-solarized
fi

