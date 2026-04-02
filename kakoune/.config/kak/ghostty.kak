provide-module ghostty %{

evaluate-commands %sh{
  [ -z "${kak_opt_windowing_modules}" ] || {
    [ -z "${kak_client_env_TMUX:-$TMUX}" ] || exit 0
    [ -n "${kak_client_env_GHOSTTY_BIN_DIR:-$GHOSTTY_BIN_DIR}" ] || echo 'fail ghostty not detected'
  }
}

define-command -hidden -params 1.. ghostty-terminal-impl %{
  nop %sh{
    if ! command -v ghostty-kak >/dev/null 2>&1; then
      echo "fail 'ghostty-kak not found in PATH'"
      exit
    fi

    action="$1"
    shift

    PWD="${kak_client_env_PWD:-$PWD}" \
    PATH="${kak_client_env_PATH:-$PATH}" \
    HOME="${kak_client_env_HOME:-$HOME}" \
    SHELL="${kak_client_env_SHELL:-$SHELL}" \
    KAK_SESSION="$kak_session" \
    KAK_CLIENT="$kak_client" \
    KKS_SESSION="$kak_session" \
    KKS_CLIENT="$kak_client" \
    ghostty-kak "$action" "$@" >/dev/null 2>&1 &
  }
}

define-command ghostty-terminal-window -params .. -docstring '
ghostty-terminal-window [<program> [<arguments>...]]: create a new Ghostty window.
If a program is provided, it is executed in the new window.' \
%{
  ghostty-terminal-impl new-window %arg{@}
}
complete-command ghostty-terminal-window shell

define-command ghostty-terminal-popup -params .. -docstring '
ghostty-terminal-popup [<program> [<arguments>...]]: fallback popup implementation for Ghostty.
Ghostty has no popup AppleScript API yet, so this opens a new window.' \
%{
  ghostty-terminal-impl new-window %arg{@}
}
complete-command ghostty-terminal-popup shell

define-command ghostty-terminal-horizontal -params .. -docstring '
ghostty-terminal-horizontal [<program> [<arguments>...]]: split the current Ghostty terminal downward.' \
%{
  ghostty-terminal-impl split:right %arg{@}
}
complete-command ghostty-terminal-horizontal shell

define-command ghostty-terminal-vertical -params .. -docstring '
ghostty-terminal-vertical [<program> [<arguments>...]]: split the current Ghostty terminal to the right.' \
%{
  ghostty-terminal-impl split:down %arg{@}
}
complete-command ghostty-terminal-vertical shell

define-command ghostty-terminal-sidebar -params .. -docstring '
ghostty-terminal-sidebar [<program> [<arguments>...]]: open a left split in Ghostty.
Ghostty sizing is controlled by its default split behavior.' \
%{
  ghostty-terminal-impl split:left %arg{@}
}
complete-command ghostty-terminal-sidebar shell

define-command vsp -docstring "split vertically" %{
  ghostty-terminal-horizontal kak -c %val{session}
}

define-command sp -docstring "split horizontally" %{
  ghostty-terminal-vertical kak -c %val{session}
}

define-command focus-left -hidden -docstring "focus left pane" %{
  ghostty-terminal-impl focus:left
}

define-command focus-right -hidden -docstring "focus right pane" %{
  ghostty-terminal-impl focus:right
}

define-command focus-up -hidden -docstring "focus up pane" %{
  ghostty-terminal-impl focus:up
}

define-command focus-down -hidden -docstring "focus down pane" %{
  ghostty-terminal-impl focus:down
}

define-command ghostty-open-bontree -docstring 'open bontree' %{
  nop %sh{
    if ! command -v ghostty-kak >/dev/null 2>&1; then
      echo "fail 'ghostty-kak not found in PATH'"
      exit
    fi

    dir="${kak_client_env_PWD:-$PWD}"
    target=""

    if [ -n "$kak_buffile" ] && [ -e "$kak_buffile" ]; then
      target="$kak_buffile"
    elif [ -e "$kak_bufname" ]; then
      target="$kak_bufname"
    fi

    if [ -n "$target" ] && [ ! -d "$target" ]; then
      target=$(realpath "$target" 2>/dev/null || printf '%s' "$target")
    else
      target=""
    fi

    dir=$(realpath "$dir" 2>/dev/null || printf '%s' "$dir")

    set -- bontree --session "$kak_session" "$dir"
    if [ -n "$target" ]; then
      set -- "$@" "$target"
    fi

    PWD="$dir" \
    PATH="${kak_client_env_PATH:-$PATH}" \
    HOME="${kak_client_env_HOME:-$HOME}" \
    SHELL="${kak_client_env_SHELL:-$SHELL}" \
    KAK_SESSION="$kak_session" \
    KAK_CLIENT="$kak_client" \
    KKS_SESSION="$kak_session" \
    KKS_CLIENT="$kak_client" \
    ghostty-kak split:left "$@" >/dev/null 2>&1 &
  }
}

}
