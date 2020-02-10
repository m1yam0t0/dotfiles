#-----------------------------------------------------------
# Variables
#-----------------------------------------------------------
# kube-ps1
KUBE_PS1_PREFIX='['
KUBE_PS1_SEPARATOR=''
KUBE_PS1_DIVIDER='|'
KUBE_PS1_SUFFIX=']'
KUBE_PS1_SYMBOL_COLOR=blue
KUBE_PS1_CTX_COLOR=blue
KUBE_PS1_NS_COLOR=blue

#-----------------------------------------------------------
# Options
#-----------------------------------------------------------
# enable settings
setopt prompt_subst
autoload -Uz vcs_info

# vcs_info
zstyle ":vcs_info:*" enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '[38;5;136m!'
zstyle ':vcs_info:git:*' unstagedstr '[38;5;160m+'
zstyle ':vcs_info:*' formats '[38;5;40m%c%u[%b][0m'
zstyle ':vcs_info:*' actionformats '[38;5;001m%c%u[%b|%a][0m'

#-----------------------------------------------------------
# Functions
#-----------------------------------------------------------

_update_vcs_info() {
    LANG=en_US.UTF-8 vcs_info
}
add-zsh-hook precmd _update_vcs_info

#-----------------------------------------------------------
# Prompt
#-----------------------------------------------------------
PROMPT='[38;5;75m[%n@%m][0m %~ ${vcs_info_msg_0_} $(kube_ps1)
%# '
