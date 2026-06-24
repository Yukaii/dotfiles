provide-module herdr %{

# ensure we're running under herdr when windowing modules are enabled
evaluate-commands %sh{
    [ -z "${kak_opt_windowing_modules}" ] || [ -n "${kak_client_env_HERDR_ENV:-$HERDR_ENV}" ] || echo 'fail herdr not detected'
}

# Run a program in a Herdr pane via `pane run`.
# Herdr pane split does not accept a command (unlike tmux split-window).
# `pane run` types into the pane's terminal, so callers must pass a shell-ready
# command line with argv boundaries already quoted.
define-command -hidden -params 2 herdr-run-in-pane %{
    nop %sh{
        pane_id="$1"
        program="$2"
        [ -z "$pane_id" ] || [ -z "$program" ] && exit 0
        pane_id_shell=$(printf '%s' "$pane_id" | sed "s/'/'\\\\''/g")
        command_line="$program; herdr pane close '$pane_id_shell'"
        herdr pane run "$pane_id" "$command_line" >/dev/null 2>&1
    }
}

# split the current pane and optionally run a program in the new pane.
# captures the pane id from the herdr pane split JSON response.
define-command -hidden -params 2.. herdr-terminal-impl %{
    evaluate-commands %sh{
        direction="$1"
        ratio="$2"
        shift 2
        cwd="${kak_client_env_PWD:-$PWD}"

        resp=$(herdr pane split --current --direction "$direction" --ratio "$ratio" \
            --cwd "$cwd" --focus \
            --env "KAK_SESSION=$kak_session" \
            --env "KAK_CLIENT=$kak_client" \
            --env "KKS_SESSION=$kak_session" \
            --env "KKS_CLIENT=$kak_client" 2>&1)

        pane_id=$(printf '%s' "$resp" | jq -r '.result.pane.pane_id // empty' 2>/dev/null)
        [ -z "$pane_id" ] && pane_id=$(printf '%s' "$resp" | head -n1 | tr -d '[:space:]')

        if [ -z "$pane_id" ] || [ $# -eq 0 ]; then
            exit 0
        fi

        pane_id_esc=$(printf '%s' "$pane_id" | sed "s/'/''/g")
        program=$(for arg do printf " '%s'" "$(printf '%s' "$arg" | sed "s/'/'\\\\''/g")"; done)
        program_esc=$(printf '%s' "${program# }" | sed "s/'/''/g")
        printf "herdr-run-in-pane '%s' '%s'" "$pane_id_esc" "$program_esc"
    }
}

define-command herdr-terminal-window -params .. -docstring '
herdr-terminal-window [<program> [<arguments>...]]: create a new herdr tab.
If a program is provided, it is executed in the new tab.' \
%{
    evaluate-commands %sh{
        cwd="${kak_client_env_PWD:-$PWD}"
        resp=$(herdr tab create --cwd "$cwd" --focus \
            --env "KAK_SESSION=$kak_session" \
            --env "KAK_CLIENT=$kak_client" \
            --env "KKS_SESSION=$kak_session" \
            --env "KKS_CLIENT=$kak_client" 2>&1)

        [ $# -eq 0 ] && exit 0

        pane_id=$(printf '%s' "$resp" | jq -r '.result.root_pane.pane_id // .result.pane.pane_id // empty' 2>/dev/null)
        [ -z "$pane_id" ] && exit 0

        pane_id_esc=$(printf '%s' "$pane_id" | sed "s/'/''/g")
        program=$(for arg do printf " '%s'" "$(printf '%s' "$arg" | sed "s/'/'\\\\''/g")"; done)
        program_esc=$(printf '%s' "${program# }" | sed "s/'/''/g")
        printf "herdr-run-in-pane '%s' '%s'" "$pane_id_esc" "$program_esc"
    }
}
complete-command herdr-terminal-window shell

define-command herdr-terminal-popup -params .. -docstring '
herdr-terminal-popup [<program> [<arguments>...]]: open a zoomed herdr pane as a popup overlay.
Splits downward at 50% then zooms the new pane. If a program is provided, it is executed in the new pane.' \
%{
    evaluate-commands %sh{
        cwd="${kak_client_env_PWD:-$PWD}"
        resp=$(herdr pane split --current --direction down --ratio 0.5 \
            --cwd "$cwd" --focus \
            --env "KAK_SESSION=$kak_session" \
            --env "KAK_CLIENT=$kak_client" \
            --env "KKS_SESSION=$kak_session" \
            --env "KKS_CLIENT=$kak_client" 2>&1)

        pane_id=$(printf '%s' "$resp" | jq -r '.result.pane.pane_id // empty' 2>/dev/null)
        [ -z "$pane_id" ] && pane_id=$(printf '%s' "$resp" | head -n1 | tr -d '[:space:]')

        [ -n "$pane_id" ] && herdr pane zoom "$pane_id" --on >/dev/null 2>&1

        if [ -z "$pane_id" ] || [ $# -eq 0 ]; then
            exit 0
        fi

        pane_id_esc=$(printf '%s' "$pane_id" | sed "s/'/''/g")
        program=$(for arg do printf " '%s'" "$(printf '%s' "$arg" | sed "s/'/'\\\\''/g")"; done)
        program_esc=$(printf '%s' "${program# }" | sed "s/'/''/g")
        printf "herdr-run-in-pane '%s' '%s'" "$pane_id_esc" "$program_esc"
    }
}
complete-command herdr-terminal-popup shell

define-command herdr-terminal-horizontal -params .. -docstring '
herdr-terminal-horizontal [<program> [<arguments>...]]: split the current herdr pane downward (bottom panel, 33%).
If a program is provided, it is executed in the new pane.' \
%{
    herdr-terminal-impl down 0.33 %arg{@}
}
complete-command herdr-terminal-horizontal shell

define-command herdr-terminal-vertical -params .. -docstring '
herdr-terminal-vertical [<program> [<arguments>...]]: split the current herdr pane to the right (right panel, 50%).
If a program is provided, it is executed in the new pane.' \
%{
    herdr-terminal-impl right 0.5 %arg{@}
}
complete-command herdr-terminal-vertical shell

define-command herdr-terminal-sidebar -params .. -docstring '
herdr-terminal-sidebar [<program> [<arguments>...]]: open a left-side sidebar pane (23% width).
Splits right then swaps left, since herdr only supports right/down split directions.
If a program is provided, it is executed in the new pane.' \
%{
    evaluate-commands %sh{
        cwd="${kak_client_env_PWD:-$PWD}"
        resp=$(herdr pane split --current --direction right --ratio 0.23 \
            --cwd "$cwd" --focus \
            --env "KAK_SESSION=$kak_session" \
            --env "KAK_CLIENT=$kak_client" \
            --env "KKS_SESSION=$kak_session" \
            --env "KKS_CLIENT=$kak_client" 2>&1)

        pane_id=$(printf '%s' "$resp" | jq -r '.result.pane.pane_id // empty' 2>/dev/null)
        [ -z "$pane_id" ] && pane_id=$(printf '%s' "$resp" | head -n1 | tr -d '[:space:]')

        [ -n "$pane_id" ] && herdr pane swap --direction left --pane "$pane_id" >/dev/null 2>&1

        if [ -z "$pane_id" ] || [ $# -eq 0 ]; then
            exit 0
        fi

        pane_id_esc=$(printf '%s' "$pane_id" | sed "s/'/''/g")
        program=$(for arg do printf " '%s'" "$(printf '%s' "$arg" | sed "s/'/'\\\\''/g")"; done)
        program_esc=$(printf '%s' "${program# }" | sed "s/'/''/g")
        printf "herdr-run-in-pane '%s' '%s'" "$pane_id_esc" "$program_esc"
    }
}
complete-command herdr-terminal-sidebar shell

define-command vsp -docstring "split vertically (left/right)" %{
    herdr-terminal-vertical kak -c %val{session}
}

define-command sp -docstring "split horizontally (top/bottom)" %{
    herdr-terminal-horizontal kak -c %val{session}
}

define-command focus-left -hidden -docstring "focus left pane" %{
    nop %sh{ herdr pane focus --direction left --current > /dev/null 2>&1 }
}

define-command focus-right -hidden -docstring "focus right pane" %{
    nop %sh{ herdr pane focus --direction right --current > /dev/null 2>&1 }
}

define-command focus-up -hidden -docstring "focus up pane" %{
    nop %sh{ herdr pane focus --direction up --current > /dev/null 2>&1 }
}

define-command focus-down -hidden -docstring "focus down pane" %{
    nop %sh{ herdr pane focus --direction down --current > /dev/null 2>&1 }
}

define-command herdr-list-windows -docstring 'list herdr tabs' %{
    evaluate-commands %sh{
        out="$(herdr tab list 2>&1 | tr '\n' '|')"
        out="$(printf '%s' "$out" | sed "s/'/''/g")"
        echo "echo -markup -- {Information}$out"
    }
}

define-command herdr-list-panels -docstring 'list herdr panes' %{
    evaluate-commands %sh{
        out="$(herdr pane list 2>&1 | tr '\n' '|')"
        out="$(printf '%s' "$out" | sed "s/'/''/g")"
        echo "echo -markup -- {Information}$out"
    }
}

define-command herdr-status -docstring 'show herdr runtime status' %{
    evaluate-commands %sh{
        out="$(herdr status 2>&1 | tr '\n' '|')"
        out="$(printf '%s' "$out" | sed "s/'/''/g")"
        echo "echo -markup -- {Information}$out"
    }
}

define-command -params ..1 herdr-close-pane -docstring '
herdr-close-pane [<pane_id>]: close a herdr pane.
Defaults to the currently focused pane.' \
%{
    nop %sh{
        if [ $# -eq 1 ]; then
            herdr pane close "$1" > /dev/null 2>&1
        else
            raw="$(herdr pane current 2>&1)"
            pane_id="$(printf '%s' "$raw" | jq -r '.result.pane.pane_id // empty' 2>/dev/null)"
            [ -z "$pane_id" ] && pane_id="$(printf '%s' "$raw" | head -n1 | tr -d '[:space:]')"
            [ -n "$pane_id" ] && herdr pane close "$pane_id" > /dev/null 2>&1
        fi
    }
}

define-command -params ..1 herdr-zoom -docstring '
herdr-zoom [<pane_id>]: toggle zoom on a herdr pane.
Defaults to the currently focused pane.' \
%{
    nop %sh{
        if [ $# -eq 1 ]; then
            herdr pane zoom "$1" --toggle > /dev/null 2>&1
        else
            herdr pane zoom --current --toggle > /dev/null 2>&1
        fi
    }
}

define-command herdr-focus -params ..1 -docstring '
herdr-focus [<client>]: focus the given kak client.
If no client is passed, brings the current pane workspace/tab to front and focuses the current client.' \
%{
    evaluate-commands %sh{
        if [ $# -eq 1 ]; then
            printf "evaluate-commands -client '%s' focus" "$1"
        else
            ws="${kak_client_env_HERDR_WORKSPACE_ID:-$HERDR_WORKSPACE_ID}"
            tab="${kak_client_env_HERDR_TAB_ID:-$HERDR_TAB_ID}"
            [ -n "$ws" ] && herdr workspace focus "$ws" > /dev/null 2>&1
            [ -n "$tab" ] && herdr tab focus "$tab" > /dev/null 2>&1
        fi
    }
}

alias global focus herdr-focus

}
