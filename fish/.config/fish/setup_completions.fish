#!/usr/bin/env fish

set completions_dir "$HOME/.config/fish/completions"

# Ensure the directory exists
mkdir -p $completions_dir

if command -q volta
    volta completions fish > $completions_dir/volta.fish
end

# Shell Integrations and Completions
if command -q oh-my-posh
  # oh-my-posh init fish --config (mbrew --prefix oh-my-posh)"/themes/uew.omp.json" > $completions_dir/oh-my-posh.fish
  oh-my-posh init fish >> $completions_dir/oh-my-posh.fish
end


if command -q sg
  sg completions fish > $completions_dir/sg.fish
end

if command -q fzf
  fzf --fish > $completions_dir/fzf.fish
end

if command -q kubectl
  kubectl completion fish > $completions_dir/kubectl.fish
end

if command -q fnm
  # Completions
  fnm completions > $completions_dir/fnm.fish
end

if command -q zoxide
  echo "
# Disable file completions for zoxide
complete -c zoxide -f

# Subcommand completions
complete -c zoxide -n '__fish_use_subcommand' -a 'add' -d 'Add a new directory or increment its rank'
complete -c zoxide -n '__fish_use_subcommand' -a 'edit' -d 'Edit the database'
complete -c zoxide -n '__fish_use_subcommand' -a 'import' -d 'Import entries from another application'
complete -c zoxide -n '__fish_use_subcommand' -a 'init' -d 'Generate shell configuration'
complete -c zoxide -n '__fish_use_subcommand' -a 'query' -d 'Search for a directory in the database'
complete -c zoxide -n '__fish_use_subcommand' -a 'remove' -d 'Remove a directory from the database'
  " >> $completions_dir/zoxide.fish
end

#if command -q mise
#    # This would also be environment initialization, similar to fnm.
#    # If `mise activate fish` provides completions, you can store them:
#    # mise activate fish > $completions_dir/mise.fish
#end

if set -q WEZTERM_PANE
  if command -q wezterm
    wezterm shell-completion --shell fish > $completions_dir/wezterm.fish
  end
end

# if command -q hub-tool
#   hub-tool completion fish > $completions_dir/hub-tool.fish
# end

if command -q atuin
  atuin gen-completions --shell fish > $completions_dir/atuin.fish
end

if command -q ov
  ov --completion fish > $completions_dir/ov.fish
end
