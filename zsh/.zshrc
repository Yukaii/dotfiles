
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

ompconfig=$(brew --prefix oh-my-posh)
# eval "$(oh-my-posh init zsh --config $ompconfig/themes/uew.omp.json)"
eval "$(starship init zsh)"

eval "$(atuin init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

export PATH="$PATH:$HOME/.bin"

source "$HOME/.config/broot/launcher/bash/br"

# Added by Windsurf
export PATH="/Users/yukai/.codeium/windsurf/bin:$PATH"

source /Users/yukai/Library/Application\ Support/org.dystroy.broot/launcher/bash/br

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/yukai/.cache/lm-studio/bin"
