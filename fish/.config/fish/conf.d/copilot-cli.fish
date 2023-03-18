function copilot_what-the-shell
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli what-the-shell $argv --shellout $TMPFILE
        if test -e "$TMPFILE"
            set FIXED_CMD (cat $TMPFILE)
            history -s (history 1 | cut -d ' ' -f 4-); history -s "$FIXED_CMD"
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

alias 'wtf-' 'copilot_what-the-shell'

function copilot_git-assist
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli git-assist $argv --shellout $TMPFILE
        if test -e "$TMPFILE"
            set FIXED_CMD (cat $TMPFILE)
            history -s (history 1 | cut -d ' ' -f 4-); history -s "$FIXED_CMD"
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

alias 'git-' 'copilot_git-assist'

function copilot_gh-assist
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli gh-assist $argv --shellout $TMPFILE
        if test -e "$TMPFILE"
            set FIXED_CMD (cat $TMPFILE)
            history -s (history 1 | cut -d ' ' -f 4-); history -s "$FIXED_CMD"
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

alias 'gh-' 'copilot_gh-assist'
alias 'wts' 'copilot_what-the-shell'