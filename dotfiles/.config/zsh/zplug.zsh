# zplug init
source $HOME/.zplug/init.zsh

# zplug install
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions', depth:1
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin

# Actually install plugins, prompt user input
if ! zplug check --verbose; then
  printf "Install? [y/N]"
  if read -q; then
    echo; zplug install
  fi
fi

# zplug load
zplug load

# fzf
if type fzf > /dev/null 2>&1; then
  source $XDG_CONFIG_HOME/zsh/fzf.zsh
fi

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# dircolor
if zplug check seebi/dircolors-solarized && type gdircolors > /dev/null 2>&1; then
  eval `gdircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
fi
