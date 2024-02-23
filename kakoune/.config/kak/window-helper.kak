hook global ModuleLoaded wezterm %{
  alias global terminal-vertical wezterm-terminal-vertical
  alias global terminal-horizontal wezterm-terminal-horizontal
  alias global terminal-popup wezterm-terminal-window
  alias global open-broot wezterm-open-broot
}

hook global ModuleLoaded tmux %{
  alias global terminal-vertical tmux-terminal-vertical
  alias global terminal-horizontal tmux-terminal-horizontal
  alias global terminal-popup tmux-popup
  alias global open-broot tmux-open-broot
}

