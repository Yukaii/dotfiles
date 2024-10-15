hook global ModuleLoaded kitty %{

# wezterm custom commands
define-command vsp -docstring "split vertically" %{
  kitty-terminal-vertical kak -c %val{session}
}

define-command sp -docstring "split horizontally" %{
  kitty-terminal-horizontal kak -c %val{session}
}

define-command kitty-terminal-horizontal -params 1.. -docstring '
kitty-terminal-horizontal <program> [<arguments>]: create a new terminal as a kitty pane
The current pane is split into two, left and right
The program passed as argument will be executed in the new terminal' \
%{
    kitty-terminal-impl --location hsplit %arg{@}
}
complete-command kitty-terminal-horizontal shell

define-command kitty-terminal-vertical -params 1.. -docstring '
kitty-terminal-horizontal <program> [<arguments>]: create a new terminal as a kitty pane
The current pane is split into two, left and right
The program passed as argument will be executed in the new terminal' \
%{
    kitty-terminal-impl --location vsplit %arg{@}
}
complete-command kitty-terminal-vertical shell

define-command kitty-terminal-impl -params 1.. -docstring '
kitty-terminal-tab <program> [<arguments>]: create a new terminal as kitty tab
The program passed as argument will be executed in the new terminal' \
%{
    nop %sh{
        match=""
        if [ -n "$kak_client_env_KITTY_WINDOW_ID" ]; then
            match="--match=window_id:$kak_client_env_KITTY_WINDOW_ID"
        fi

        listen=""
        if [ -n "$kak_client_env_KITTY_LISTEN_ON" ]; then
            listen="--to=$kak_client_env_KITTY_LISTEN_ON"
        fi

        kitty @ $listen launch --no-response --cwd="$PWD" $match "$@"
    }
}
complete-command kitty-terminal-impl shell


define-command kitty-terminal-action -params 1.. -docstring '
kitty-terminal-action <program> [<arguments>]: create a new terminal as kitty tab
The program passed as argument will be executed in the new terminal' \
%{
    nop %sh{
        match=""
        if [ -n "$kak_client_env_KITTY_WINDOW_ID" ]; then
            match="--match=window_id:$kak_client_env_KITTY_WINDOW_ID"
        fi

        listen=""
        if [ -n "$kak_client_env_KITTY_LISTEN_ON" ]; then
            listen="--to=$kak_client_env_KITTY_LISTEN_ON"
        fi

        kitty @ $listen action --no-response $match "$@"
    }
}
complete-command kitty-terminal-action shell

define-command focus-left -hidden -docstring "focus left pane" %{
  kitty-terminal-action neighboring_window left
}

define-command focus-right -hidden -docstring "focus right pane" %{
  kitty-terminal-action neighboring_window right
}

define-command focus-up -hidden -docstring "focus up pane" %{
  kitty-terminal-action neighboring_window top
}

define-command focus-down -hidden -docstring "focus down pane" %{
  kitty-terminal-action neighboring_window bottom
}


define-command kitty-popup -params 1.. -docstring '
kitty-popup <program> [<arguments>]: create a new terminal as a kitty popup
The program passed as argument will be executed in the new terminal' \
%{
  kitty-terminal-impl --bias=30 --type=os-window  %arg{@}
}
complete-command kitty-popup shell

# define-command tmux-open-broot -docstring 'open broot' %{
#   evaluate-commands nop %sh{
#     env_line="env EDITOR=\"kks edit\" KKS_SESSION=$kak_session KKS_CLIENT=$kak_client"
#     # Optionally, set the BROOT_LOG environment variable for debugging
#     # BROOT_LOG=debug

#     # Use the environment variable to get the current tmux pane ID
#     current_pane_id="${kak_client_env_TMUX_PANE}"

#     # List all panes and check if a broot process is running in any of them, excluding the current pane
#     broot_pane_id=$(tmux list-panes -F '#{pane_title} #{pane_id}' | grep -E '^broot ' | grep -v "$current_pane_id" | cut -d ' ' -f 2)
#     dir=$(dirname "$kak_bufname")
#     base=$(basename "$kak_bufname")

#     if [ -z "$broot_pane_id" ]; then
#         # If no broot process is found, split the pane and run broot
#         tmux split-window -hb -l 23% "$env_line broot --listen $kak_session $dir"
#     else
#         # If a broot process is already running in a different pane, prepare to send commands to it
#         root=$(broot --send "$kak_session" --get-root)
#         absolute=$(realpath "$PWD/$dir")
#         if [ "$root" != "$absolute" ] && [ "$dir" != '.' ]; then
#             broot --send "$kak_session" -c ":focus $dir"
#         fi
#         # Activate the pane with the broot process
#         tmux select-pane -t "$broot_pane_id"
#     fi
#   }
# }

}
