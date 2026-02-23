provide-module ykmx %{

# ensure we're running under ykmx when windowing modules are enabled
evaluate-commands %sh{
    [ -z "${kak_opt_windowing_modules}" ] || [ -n "${kak_client_env_YKMX_CONTROL_PIPE:-$YKMX_CONTROL_PIPE}" ] || echo 'fail ykmx not detected'
}

define-command -hidden -params 1.. ykmx-ctl %{
    nop %sh{
        ykmx ctl "$@" > /dev/null
    }
}

define-command ykmx-terminal-window -params .. -docstring '
ykmx-terminal-window: create a new ykmx window in the current session.
Arguments are accepted for API parity and currently ignored by ykmx.' \
%{
    ykmx-ctl new-window
}

define-command ykmx-terminal-popup -params .. -docstring '
ykmx-terminal-popup: open the configured popup panel in the current ykmx session.
When program arguments are provided, runs that command in the popup.' \
%{
    ykmx-ctl open-popup --cwd %val{client_env_PWD} %arg{@}
}

define-command ykmx-terminal-command -params 1 -docstring '
ykmx-terminal-command <name>: dispatch plugin command by name via ykmx ctl.' \
%{
    ykmx-ctl command %arg{1}
}

define-command ykmx-terminal-horizontal -params .. -docstring '
ykmx-terminal-horizontal: open a bottom panel in ykmx.
Arguments are accepted for API parity and currently ignored by ykmx.' \
%{
    evaluate-commands %sh{
        screen="$(ykmx ctl status 2>/dev/null | awk -F= '/^screen=/{print $2; exit}')"
        if [ -z "$screen" ]; then
            echo "fail 'ykmx status unavailable'"
            exit
        fi
        w="${screen%x*}"
        h="${screen#*x}"
        ph=$(( h / 3 ))
        [ "$ph" -lt 10 ] && ph=10
        y=$(( h - ph - 3 ))
        [ "$y" -lt 0 ] && y=0
        echo "ykmx-ctl open-panel 0 $y $w $ph --cwd $kak_client_env_PWD"
    }
}

define-command ykmx-terminal-vertical -params .. -docstring '
ykmx-terminal-vertical: open a right-side panel in ykmx.
Arguments are accepted for API parity and currently ignored by ykmx.' \
%{
    evaluate-commands %sh{
        screen="$(ykmx ctl status 2>/dev/null | awk -F= '/^screen=/{print $2; exit}')"
        if [ -z "$screen" ]; then
            echo "fail 'ykmx status unavailable'"
            exit
        fi
        w="${screen%x*}"
        h="${screen#*x}"
        pw=$(( w / 2 ))
        [ "$pw" -lt 40 ] && pw=40
        x=$(( w - pw ))
        [ "$x" -lt 0 ] && x=0
        ph=$(( h - 3 ))
        [ "$ph" -lt 6 ] && ph=6
        echo "ykmx-ctl open-panel $x 0 $pw $ph --cwd $kak_client_env_PWD"
    }
}

define-command ykmx-terminal-sidebar -params .. -docstring '
ykmx-terminal-sidebar: open a left-side sidebar panel (23% width) in ykmx.
Arguments are accepted for API parity and currently ignored by ykmx.' \
%{
    evaluate-commands %sh{
        screen="$(ykmx ctl status 2>/dev/null | awk -F= '/^screen=/{print $2; exit}')"
        if [ -z "$screen" ]; then
            echo "fail 'ykmx status unavailable'"
            exit
        fi
        w="${screen%x*}"
        h="${screen#*x}"
        pw=$(( w * 23 / 100 ))
        [ "$pw" -lt 24 ] && pw=24
        ph=$(( h - 3 ))
        [ "$ph" -lt 6 ] && ph=6
        echo "ykmx-ctl open-panel 0 0 $pw $ph --cwd $kak_client_env_PWD"
    }
}

define-command ykmx-list-windows -docstring 'list ykmx windows' %{
    evaluate-commands %sh{
        out="$(ykmx ctl list-windows 2>&1 | tr '\n' '|' )"
        out="$(printf %s "$out" | sed "s/'/''/g")"
        echo "echo -markup -- {Information}$out"
    }
}

define-command ykmx-list-panels -docstring 'list ykmx panels' %{
    evaluate-commands %sh{
        out="$(ykmx ctl list-panels 2>&1 | tr '\n' '|' )"
        out="$(printf %s "$out" | sed "s/'/''/g")"
        echo "echo -markup -- {Information}$out"
    }
}

define-command ykmx-status -docstring 'show ykmx runtime status' %{
    evaluate-commands %sh{
        out="$(ykmx ctl status 2>&1 | tr '\n' '|' )"
        out="$(printf %s "$out" | sed "s/'/''/g")"
        echo "echo -markup -- {Information}$out"
    }
}

define-command -params 1 ykmx-hide-panel -docstring 'hide ykmx panel by id' %{
    ykmx-ctl hide-panel %arg{1}
}

define-command -params 1 ykmx-show-panel -docstring 'show ykmx panel by id' %{
    ykmx-ctl show-panel %arg{1}
}

define-command ykmx-focus -params ..1 -docstring '
ykmx-focus [<client>]: focus current client (ykmx currently has no external focus target API)' \
%{
    evaluate-commands %sh{
        if [ $# -eq 1 ]; then
            printf "evaluate-commands -client '%s' focus" "$1"
        else
            echo "focus"
        fi
    }
}

alias global focus ykmx-focus

}
