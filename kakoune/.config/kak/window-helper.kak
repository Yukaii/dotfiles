define-command terminal-popup-wrapper -params .. -docstring '
terminal-popup-wrapper [<program> [<arguments>...]]: open a popup using the active terminal multiplexer.
Uses herdr-popup under Herdr, tsm popup under tmux when available, and tmux-popup as a fallback.' \
%{
  evaluate-commands %sh{
    quote_arg() {
      printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\''/g")"
    }

    emit_kak_args() {
      for arg do
        printf ' %s' "$(quote_arg "$arg")"
      done
    }

    if [ -n "${kak_client_env_HERDR_ENV:-${HERDR_ENV:-}}" ] && command -v herdr-popup >/dev/null 2>&1; then
      printf 'nop %%sh{ herdr-popup'
      emit_kak_args "$@"
      printf ' >/dev/null 2>&1 & }'
      exit 0
    fi

    if [ -n "${kak_client_env_TMUX:-${TMUX:-}}" ] && command -v tsm >/dev/null 2>&1; then
      program=""
      for arg do
        quoted=$(quote_arg "$arg")
        if [ -z "$program" ]; then
          program="$quoted"
        else
          program="$program $quoted"
        fi
      done

      if [ -n "$program" ]; then
        printf 'nop %%sh{ tsm popup %s >/dev/null 2>&1 & }' "$(quote_arg "$program")"
      else
        printf 'nop %%sh{ tsm popup >/dev/null 2>&1 & }'
      fi
      exit 0
    fi

    if [ -n "${kak_client_env_TMUX:-${TMUX:-}}" ]; then
      printf 'tmux-popup'
      emit_kak_args "$@"
      exit 0
    fi

    echo "fail 'terminal-popup-wrapper: no supported popup backend detected'"
  }
}
complete-command terminal-popup-wrapper shell

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
  alias global terminal-popup terminal-popup-wrapper
  alias global terminal-sidebar herdr-terminal-sidebar
}
