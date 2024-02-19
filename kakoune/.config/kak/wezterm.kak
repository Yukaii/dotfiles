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

define-command wezterm-open-broot -docstring 'open broot' %{
  evaluate-commands nop %sh{
    export EDITOR="kks edit"
    export KKS_SESSION="$kak_session"
    export KKS_CLIENT="$kak_client"
    # export BROOT_LOG=debug

    pane_id="${kak_client_env_WEZTERM_PANE}"

		tab_id=$(wezterm cli list --format json | jq -r ".[] | select(.pane_id==$pane_id) | .tab_id")
		broot_pane_id=$(wezterm cli list --format json | jq -r ".[] | select((.tab_id==$tab_id) and (.title==\"broot\")) | .pane_id")

		if [ -z "$broot_pane_id" ]; then
      wezterm cli split-pane --left --percent 23 -- broot --listen "$kak_session"
		else
			root=$(broot --send "$kak_session" --get-root)
      dir=$(dirname $kak_bufname)
      absolute=$(realpath $PWD)/$dir
      [ $root != $absolute ] && [ $dir != '.' ] && broot --send "$kak_session" -c ":focus $dir"
			wezterm cli activate-pane --pane-id $broot_pane_id
		fi
  }
}

}
