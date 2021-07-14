# iterm2_shell_integration
if [ -f ~/.iterm2/iterm2_shell_integration.zsh ]; then
    source ~/.iterm2/iterm2_shell_integration.zsh
    # environment settings
    export ITERM2_SQUELCH_MARK=1

    # custom variable for iterm2 status bar
    iterm2_print_user_vars(){
        iterm2_set_user_var kubeContext "$(kube_ps1)"
    }
fi