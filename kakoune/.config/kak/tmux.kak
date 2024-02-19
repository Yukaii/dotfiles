hook global ModuleLoaded tmux %{

# wezterm custom commands
define-command vsp -docstring "split vertically" %{
  tmux-terminal-horizontal kak -c %val{session}
}

define-command sp -docstring "split horizontally" %{
  tmux-terminal-vertical kak -c %val{session}
}

define-command focus-left -hidden -docstring "focus left pane" %{
  nop %sh{
    TMUX="${kak_client_env_TMUX}" tmux select-pane -t "${kak_client_env_TMUX_PANE}" -L > /dev/null
  }
}

define-command focus-right -hidden -docstring "focus right pane" %{
  nop %sh{
    TMUX="${kak_client_env_TMUX}" tmux select-pane -t "${kak_client_env_TMUX_PANE}" -R > /dev/null
  }
}

define-command focus-up -hidden -docstring "focus up pane" %{
  nop %sh{
    TMUX="${kak_client_env_TMUX}" tmux select-pane -t "${kak_client_env_TMUX_PANE}" -U > /dev/null
  }
}

define-command focus-down -hidden -docstring "focus down pane" %{
  nop %sh{
    TMUX="${kak_client_env_TMUX}" tmux select-pane -t "${kak_client_env_TMUX_PANE}" -D > /dev/null
  }
}

define-command tmux-popup -params 1.. -docstring '
tmux-popup <program> [<arguments>]: create a new terminal as a tmux popup
The program passed as argument will be executed in the new terminal' \
%{
    tmux-terminal-impl 'popup -w 80% -h 70%' %arg{@}
}


}
