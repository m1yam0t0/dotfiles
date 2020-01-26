# init zinit
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/fast-syntax-highlighting

zinit ice pick"kube-ps1.sh"
zinit light "jonmosco/kube-ps1"

zinit ice from:"gh-r" as"program"
zinit load "junegunn/fzf-bin"

# if you already installed coreutils, load dircolors-solarized
if type gdircolors > /dev/null 2>&1; then
    zinit ice atclone"gdircolors dircolors.256dark > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
    zinit light seebi/dircolors-solarized
fi

# load plugin config
PLUGIN_CONFIG_DIR=$XDG_CONFIG_HOME/zsh/plugins
for f ($PLUGIN_CONFIG_DIR/*.zsh) {source $f}
