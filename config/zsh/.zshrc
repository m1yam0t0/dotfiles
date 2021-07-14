# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# asdf
if [ -d "${ASDF_DIR}" ]; then
    source ${ASDF_DIR}/asdf.sh
    fpath=(${ASDF_DIR}/completions $fpath)
fi

# source *.zsh
for rc in $(ls ${ZDOTDIR}/*.zsh);
do
    source $rc
done

# Local Settings
[[ -f ~/.zshrc.local ]] || source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# for profiling
#if (which zprof > /dev/null 2>&1) ;then
#    zprof
#fi
