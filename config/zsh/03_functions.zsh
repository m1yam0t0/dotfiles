#-----------------------------------------------------------
# Tab title
#-----------------------------------------------------------

_precmd_tabtitle() {
    pwd=$(pwd)
    cwd=${pwd##*/}
    print -Pn "\e]0;$cwd\a"
}

_preexec_tabtitle() {
    printf "\033]0;%s\a" "${1%% *} | $cwd"
}

#-----------------------------------------------------------
# ls
#-----------------------------------------------------------

_chpwd_ls() {
    if [[ ! -r $PWD ]]; then
        return
    fi

    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--group-directories-first' '--color=always')

    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=${COLUMNS} command ${cmd_ls} ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "${ls_result}" | wc -l | tr -d ' ')
    if [ ${ls_lines} -gt 10 ]; then
        echo "${ls_result}" | head -n 5
        echo '...'
        echo "${ls_result}" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "${ls_result}"
    fi
}

#-----------------------------------------------------------
# Plugins
#-----------------------------------------------------------
## adsf
# install latest version & update '.tool-versions'
_asdf_upgrade_plugin() {

    local plugin=$1
    echo "Upgrade ${plugin}..."

    asdf install ${plugin} latest
    local ret=$?

    if [ ${ret} -ne 0 ];then
        return false
    fi

    asdf reshim
    local version=$(asdf latest ${plugin})
    asdf global ${plugin} ${version}

    echo "Latest version of ${plugin} is installed. (version=${version})"
}

# exec '_asdf_upgrade_plugin' to all plugin
_asdf_upgrade_all_plugins() {

    echo "Updating all asdf plugins..."
    asdf plugin update --all

    echo "Updating each plugin to the latest version..."
    for p in $(asdf plugin-list)
    do
        _asdf_upgrade_plugin $p
    done
}

## fzf
# history
_fzf-history() {
  BUFFER=$( fc -l 1 | fzf +m +s --tac | sed 's/ *[0-9]* *//' )
  CURSOL=$#BUFFER

  zle reset-prompt
}
zle -N _fzf-history

# cd ghq list
_fzf-ghq() {
  local selected
  selected=$( ghq list --full-path | fzf +m )

  if [ -n "${selected}" ]; then
    BUFFER="cd ${selected}"
    zle accept-line
  fi

  zle reset-prompt
}
zle -N _fzf-ghq

# git switch
_fzf-git-switch() {
  local selected
  selected=$( git branch --all | grep -v HEAD | fzf +m | sed "s/.* //" | sed "s#remotes/[^/]*/##" )

  if [ -n "${selected}" ]; then
    git switch ${selected}
  fi
}

# kill process
_fzf-kill() {
  local pid
  pid=$( ps -ef | sed 1d | fzf -m | awk '{print $2}' )

  if [ -n "${pid}" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
}
