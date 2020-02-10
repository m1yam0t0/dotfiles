# vi mode
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey "^h" backward-delete-char

# fzf function
bindkey '^r' _fzf-history
bindkey '^g' _fzf-ghq
