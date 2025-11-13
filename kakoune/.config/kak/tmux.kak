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

define-command -override -hidden -params 2.. tmux-terminal-impl %{
  evaluate-commands %sh{
    tmux=${kak_client_env_TMUX:-$TMUX}
    if [ -z "$tmux" ]; then
      echo "fail 'This command is only available in a tmux session'"
      exit
    fi
    tmux_args="$1"
    if [ "${1%%-*}" = split ]; then
      tmux_args="$tmux_args -t ${kak_client_env_TMUX_PANE}"
    elif [ "${1%% *}" = new-window ]; then
      session_id=$(tmux display-message -p -t ${kak_client_env_TMUX_PANE} '#{session_id}')
      tmux_args="$tmux_args -t $session_id"
    fi
    shift
    # ideally we should escape single ';' to stop tmux from interpreting it as a new command
    # but that's probably too rare to care
    if [ -n "$TMPDIR" ]; then
      TMUX=$tmux tmux $tmux_args env TMPDIR="$TMPDIR" "$@" < /dev/null > /dev/null 2>&1 &
    else
      TMUX=$tmux tmux $tmux_args "$@" < /dev/null > /dev/null 2>&1 &
    fi
  }
}


define-command tmux-popup -params 1.. -docstring '
tmux-popup <program> [<arguments>]: create a new terminal as a tmux popup
The program passed as argument will be executed in the new terminal' \
%{
  tmux-terminal-impl "popup -w 90%% -h 80%% -E -d %val{client_env_PWD}" %arg{@}
}
complete-command tmux-popup shell

define-command tmux-terminal-sidebar -params 1.. -docstring '
tmux-terminal-sidebar <program> [<arguments>]: create a new terminal as a narrow horizontal pane (23%)
Useful for persistent sidebars like file pickers or git diff lists.' \
%{
  tmux-terminal-impl 'split-window -hb -l 23%%' %arg{@}
}
complete-command tmux-terminal-sidebar shell

define-command tmux-open-git-diff-files -docstring 'open persistent git diff file picker in sidebar' %{
  evaluate-commands nop %sh{
    tmux=${kak_client_env_TMUX:-$TMUX}
    if [ -z "$tmux" ]; then
      echo "fail 'tmux-open-git-diff-files: tmux session not detected'"
      exit
    fi

    env_line="env EDITOR=\"kks edit\" KKS_SESSION=$kak_session KKS_CLIENT=$kak_client"
    TMUX="$tmux" tmux split-window -hb -l 23% "$env_line kks-git-diff-files --persistent"
  }
}
complete-command tmux-open-git-diff-files shell

define-command tmux-open-broot -docstring 'open broot' %{
  evaluate-commands nop %sh{
    env_line="env EDITOR=\"kks edit\" KKS_SESSION=$kak_session KKS_CLIENT=$kak_client"
    # Optionally, set the BROOT_LOG environment variable for debugging
    # BROOT_LOG=debug

    # Use the environment variable to get the current tmux pane ID
    current_pane_id="${kak_client_env_TMUX_PANE}"

    # List all panes and check if a broot process is running in any of them, excluding the current pane
    broot_pane_id=$(tmux list-panes -F '#{pane_title} #{pane_id}' | grep -E '^broot ' | grep -v "$current_pane_id" | cut -d ' ' -f 2)
    dir=$(dirname "$kak_bufname")
    base=$(basename "$kak_bufname")
    absolute=$(realpath "$PWD/$dir")

    if [ -z "$broot_pane_id" ]; then
      # If no broot process is found, split the pane and run broot
      tmux split-window -hb -l 23% "$env_line broot --listen $kak_session $dir"

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
        relative_path=$(grealpath --relative-to="$root" "$absolute")
        broot --send "$kak_session" -c ":focus $relative_path"
      fi

      broot --send "$kak_session" -c ":select $base"
      # Activate the pane with the broot process
      tmux select-pane -t "$broot_pane_id"
    fi
  }
}

}
