hook global ModuleLoaded wezterm %{

# wezterm custom commands
define-command vsp -docstring "split vertically" %{
  wezterm-terminal-horizontal kak -c %val{session}
}

define-command sp -docstring "split horizontally" %{
  wezterm-terminal-vertical kak -c %val{session}
}

define-command focus-left -hidden -docstring "focus left pane" %{
  nop %sh{
    wezterm cli activate-pane-direction left
  }
}

define-command focus-right -hidden -docstring "focus right pane" %{
  nop %sh{
    wezterm cli activate-pane-direction right
  }
}

define-command focus-up -hidden -docstring "focus up pane" %{
  nop %sh{
    wezterm cli activate-pane-direction up
  }
}

define-command focus-down -hidden -docstring "focus down pane" %{
  nop %sh{
    wezterm cli activate-pane-direction down
  }
}

}
