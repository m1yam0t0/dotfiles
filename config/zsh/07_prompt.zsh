#-----------------------------------------------------------
# Variables
#-----------------------------------------------------------
# color
BLUE=$'\e[38;5;33m'
GREEN=$'\e[38;5;64m'
YELLOW=$'\e[38;5;136m'
RED=$'\e[38;5;160m'
RESET=$'\e[0m'

#-----------------------------------------------------------
# Options
#-----------------------------------------------------------
# enable settings
setopt prompt_subst
autoload -Uz vcs_info

# vcs_info
zstyle ":vcs_info:*" enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "${YELLOW}!"
zstyle ':vcs_info:git:*' unstagedstr "${RED}+"
zstyle ':vcs_info:*' formats "${GREEN}%c%u[%b]${RESET}"
zstyle ':vcs_info:*' actionformats "${RED}%c%u[%b|%a]${RESET}"

#-----------------------------------------------------------
# Functions
#-----------------------------------------------------------
# get git branch status
_update_vcs_info() {
    LANG=en_US.UTF-8 vcs_info
}
add-zsh-hook precmd _update_vcs_info

#-----------------------------------------------------------
# Prompt
#-----------------------------------------------------------
PROMPT_CHAR=$'\u276f'
PROMPT_DEFAULT=${BLUE}${PROMPT_CHAR}${RESET}
PROMPT_ERROR=${RED}${PROMPT_CHAR}${RESET}
PROMPT='
%~ ${vcs_info_msg_0_}
%(?.%{%G${PROMPT_DEFAULT}%}.%{%G${PROMPT_ERROR}%}) '
