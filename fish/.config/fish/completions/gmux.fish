# gmux fish completion
function __gmux_complete
    set -l current (commandline -ct)
    command gmux completions __complete fish -- "$current" (commandline -opc) 2>/dev/null
end

complete -c gmux -f -a '(__gmux_complete)'
