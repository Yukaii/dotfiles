hook global ModuleLoaded wezterm %{
  alias global terminal-vertical wezterm-terminal-vertical
  alias global terminal-horizontal wezterm-terminal-horizontal
  alias global terminal-popup wezterm-terminal-window
  alias global open-broot wezterm-open-broot
  alias global open-bontree wezterm-open-bontree
  alias global terminal-sidebar wezterm-terminal-horizontal
}

hook global ModuleLoaded ghostty %{
  alias global terminal-vertical ghostty-terminal-vertical
  alias global terminal-horizontal ghostty-terminal-horizontal
  alias global terminal-popup ghostty-terminal-popup
  alias global open-bontree ghostty-open-bontree
  alias global terminal-sidebar ghostty-terminal-sidebar
}

hook global ModuleLoaded tmux %{
  alias global terminal-vertical tmux-terminal-vertical
  alias global terminal-horizontal tmux-terminal-horizontal
  alias global terminal-popup tmux-popup
  alias global open-broot tmux-open-broot
  alias global open-bontree tmux-open-bontree
  alias global terminal-sidebar tmux-terminal-sidebar
}

hook global ModuleLoaded kitty %{
  alias global terminal-vertical kitty-terminal-vertical
  alias global terminal-horizontal kitty-terminal-horizontal
  alias global terminal-popup kitty-popup
  # alias global open-broot kitty-open-broot
  alias global terminal-sidebar kitty-terminal-horizontal
}

hook global ModuleLoaded ykmx %{
  alias global terminal-vertical ykmx-terminal-vertical
  alias global terminal-horizontal ykmx-terminal-horizontal
  alias global terminal-popup ykmx-terminal-popup
  alias global terminal-sidebar ykmx-terminal-sidebar
}

hook global ModuleLoaded herdr %{
  alias global terminal-vertical herdr-terminal-vertical
  alias global terminal-horizontal herdr-terminal-horizontal
  alias global terminal-popup herdr-terminal-popup
  alias global terminal-sidebar herdr-terminal-sidebar
}
