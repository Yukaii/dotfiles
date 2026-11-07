
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$VOLTA_HOME/bin:$PATH"

ompconfig=$(brew --prefix oh-my-posh)
# eval "$(oh-my-posh init zsh --config $ompconfig/themes/uew.omp.json)"
eval "$(starship init zsh)"

# Auto-switch themes with macOS system appearance.
# Checks on every prompt so Control Center light/dark toggle applies instantly.
# appearance-mode/bat-theme live in ~/.bin (absolute path: PATH order varies).
_starship_auto_appearance() {
  local mode="$("$HOME/.bin/appearance-mode")"
  if [[ "$mode" == "dark" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship-dark.toml"
  else
    export STARSHIP_CONFIG="$HOME/.config/starship-light.toml"
  fi
  export BAT_THEME="$("$HOME/.bin/appearance-bat-theme" "$mode")"
  export FZF_DEFAULT_OPTS="--color=$mode"
}
autoload -U add-zsh-hook
add-zsh-hook precmd _starship_auto_appearance
_starship_auto_appearance

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

# Added by Windsurf
export PATH="/Users/yukai/.codeium/windsurf/bin:$PATH"

# Added by Antigravity
export PATH="/Users/yukai/.antigravity/antigravity/bin:$PATH"
source /Users/yukai/.secrets.sh

# Bun global bins (cf, etc.) — appended so they don't shadow existing tools
export PATH="$PATH:/Users/yukai/.bun/bin"

# >>> otty shell integration >>>
# Added by Otty — toggle in Settings > Shell > Shell Integration.
# Inert unless launched by Otty (it sets $OTTY_SHELL_INTEGRATION).
if [ -n "$OTTY_SHELL_INTEGRATION" ] && [ -r "$OTTY_SHELL_INTEGRATION/otty-integration.zsh" ]; then
  . "$OTTY_SHELL_INTEGRATION/otty-integration.zsh"
fi
# <<< otty shell integration <<<


# Added by Antigravity CLI installer
export PATH="/Users/yukai/.local/bin:$PATH"

eval "$(~/.local/bin/mise activate zsh)"
