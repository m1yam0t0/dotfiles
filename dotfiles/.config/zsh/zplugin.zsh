# init zplugin
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-completions
zplugin light zsh-users/zsh-syntax-highlighting

zplugin ice pick"kube-ps1.sh"
zplugin light "jonmosco/kube-ps1"

zplugin ice from:"gh-r" as"program"
zplugin load "junegunn/fzf-bin"

# if you already installed coreutils, load dircolors-solarized
if type gdircolors > /dev/null 2>&1; then
    zplugin ice atclone"gdircolors dircolors.256dark > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
    zplugin light seebi/dircolors-solarized
fi

# load plugin config
PLUGIN_CONFIG_DIR=$XDG_CONFIG_HOME/zsh/plugins
for f ($PLUGIN_CONFIG_DIR/*.zsh) {zplugin snippet $f}
