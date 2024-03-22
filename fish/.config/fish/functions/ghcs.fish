function ghcs
    set TARGET "shell"
    set GH_DEBUG $GH_DEBUG

    set __USAGE "
    Wrapper around 'gh copilot suggest' to suggest a command based on a natural language description of the desired output effort.
    Supports executing suggested commands if applicable.

    USAGE
      ghcs [flags] <prompt>

    FLAGS
      -d, --debug              Enable debugging
      -h, --help               Display help usage
      -t, --target target      Target for suggestion; must be shell, gh, git
                               default: \"$TARGET\"

    EXAMPLES
    - Guided experience
      ghcs <your prompt>

    - Git use cases
      ghcs -t git \"Undo the most recent local commits\"
      ghcs -t git \"Clean up local branches\"
      ghcs -t git \"Setup LFS for images\"

    - Working with the GitHub CLI in the terminal
      ghcs -t gh \"Create pull request\"
      ghcs -t gh \"List pull requests waiting for my review\"
      ghcs -t gh \"Summarize work I have done in issues and pull requests for promotion\"

    - General use cases
      ghcs \"Kill processes holding onto deleted files\"
      ghcs \"Test whether there are SSL/TLS issues with github.com\"
      ghcs \"Convert SVG to PNG and resize\"
      ghcs \"Convert MOV to animated PNG\""

    for flag in $argv
        switch $flag
            case '-d' '--debug'
                set GH_DEBUG api
            case '-h' '--help'
                echo $__USAGE
                return 0
            case '-t' '--target'
                set TARGET (next)
        end
    end

    set TMPFILE "(mktemp -t gh-copilotXXX)"

    function ghcs_clean --on-process %self --on-event exit
        rm -f $TMPFILE
    end

    if GH_DEBUG=$GH_DEBUG gh copilot suggest -t $TARGET $argv --shell-out $TMPFILE
        if test -s $TMPFILE
            set FIXED_CMD "(cat $TMPFILE)"
            history --save $FIXED_CMD
            echo
            eval $FIXED_CMD
        end
    else
        return 1
    end
end

function ghce
    set GH_DEBUG $GH_DEBUG

    set __USAGE "
    Wrapper around \`gh copilot explain\` to explain a given input command in natural language.

    USAGE
      ghce [flags] <command>

    FLAGS
      -d, --debug   Enable debugging
      -h, --help    Display help usage

    EXAMPLES
    # View disk usage, sorted by size
    ghce 'du -sh | sort -h'

    # View git repository history as text graphical representation
    ghce 'git log --oneline --graph --decorate --all'

    # Remove binary objects larger than 50 megabytes from git history
    ghce 'bfg --strip-blobs-bigger-than 50M'"

    for flag in $argv
        switch $flag
            case '-d' '--debug'
                set GH_DEBUG api
            case '-h' '--help'
                echo $__USAGE
                return 0
        end
    end

    GH_DEBUG=$GH_DEBUG gh copilot explain $argv
end
