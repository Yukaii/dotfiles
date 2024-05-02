
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

ompconfig=$(brew --prefix oh-my-posh)
eval "$(oh-my-posh init zsh --config $ompconfig/themes/uew.omp.json)"

eval "$(atuin init zsh)"
eval "$(fzf --zsh)"

export PATH="$PATH:$HOME/.bin"
