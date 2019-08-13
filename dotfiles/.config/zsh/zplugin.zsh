# init zplugin
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin light zsh-users/zsh-autosuggestions
zplugin light zsh-users/zsh-completions
zplugin light zdharma/fast-syntax-highlighting

zplugin ice from:"gh-r" as"program"
zplugin load "junegunn/fzf-bin"

# if you already installed coreutils, load dircolors-solarized
if type gdircolors > /dev/null 2>&1; then
    zplugin ice atclone"gdircolors dircolors.256dark > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
    zplugin light seebi/dircolors-solarized
fi

# fzf
if type fzf > /dev/null 2>&1; then
    source $XDG_CONFIG_HOME/zsh/fzf.zsh
fi

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
