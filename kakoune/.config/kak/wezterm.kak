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
    # Optionally, set the BROOT_LOG environment variable for debugging
    # export BROOT_LOG=debug

    pane_id="${kak_client_env_WEZTERM_PANE}"

    tab_id=$(wezterm cli list --format json | jq -r ".[] | select(.pane_id==$pane_id) | .tab_id")
    broot_pane_id=$(wezterm cli list --format json | jq -r ".[] | select((.tab_id==$tab_id) and (.title==\"broot\")) | .pane_id")

    dir=$(dirname "$kak_bufname")
    base=$(basename "$kak_bufname")
    absolute=$(realpath "$PWD/$dir")

    if [ -z "$broot_pane_id" ]; then
      # If no broot process is found, split the pane and run broot
      wezterm cli split-pane --left --percent 23 -- broot --listen "$kak_session" "$dir"

      # Wait until broot returns a valid response for the session or timeout after 2 seconds
      max_wait=20  # 2 seconds total (20 * 0.1s)
      wait_count=0

      while true; do
        root=$(broot --send "$kak_session" --get-root)
        if [ -n "$root" ]; then
          break
        fi
        sleep 0.1
        wait_count=$((wait_count + 1))

        # Check if max_wait time has been exceeded
        if [ "$wait_count" -ge "$max_wait" ]; then
          echo "Timeout waiting for broot to initialize."
          break
        fi
      done

      broot --send "$kak_session" -c ":select $base"
    else
      # If a broot process is already running in a different pane, prepare to send commands to it
      root=$(broot --send "$kak_session" --get-root)
      if [ "$root" != "$absolute" ] && [ "$dir" != '.' ]; then
        relative_path=$(realpath --relative-to="$root" "$absolute")
        broot --send "$kak_session" -c ":focus $relative_path"
      fi

      broot --send "$kak_session" -c ":select $base"
      # Activate the pane with the broot process
      wezterm cli activate-pane --pane-id "$broot_pane_id"
    fi
  }
}

define-command wezterm-open-bontree -docstring 'open bontree' %{
  evaluate-commands nop %sh{
    export EDITOR="kks edit"
    export KKS_SESSION="$kak_session"
    export KKS_CLIENT="$kak_client"

    dir="${kak_client_env_PWD:-$PWD}"
    target=""
    focus=""
    session="$kak_session"

    if [ -n "$kak_buffile" ] && [ -e "$kak_buffile" ]; then
      target="$kak_buffile"
    elif [ -e "$kak_bufname" ]; then
      target="$kak_bufname"
    fi

    if [ -n "$target" ] && [ ! -d "$target" ]; then
      focus="$target"
    fi

    dir=$(realpath "$dir" 2>/dev/null || printf '%s' "$dir")
    if ! bontree ctl --session "$session" ping >/dev/null 2>&1; then
      if [ -n "$focus" ]; then
        focus=$(realpath "$focus" 2>/dev/null || printf '%s' "$focus")
        wezterm cli split-pane --left --percent 23 -- bontree --session "$session" "$dir" "$focus"
      else
        wezterm cli split-pane --left --percent 23 -- bontree --session "$session" "$dir"
      fi
      exit 0
    fi

    bontree_pane_id=$(wezterm cli list --format json | jq -r ".[] | select(((.title // \"\") | startswith(\"bontree\")) or ((.foreground_process_name // \"\") | test(\"/bontree$|^bontree$\"))) | .pane_id" | head -n 1)

    if [ -n "$focus" ]; then
      focus=$(realpath "$focus" 2>/dev/null || printf '%s' "$focus")
      bontree ctl --session "$session" focus --path "$focus" >/dev/null 2>&1
    fi

    if [ -n "$bontree_pane_id" ]; then
      wezterm cli activate-pane --pane-id "$bontree_pane_id"
    fi
  }
}

}
