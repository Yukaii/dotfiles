# AppleScript language support for Kakoune
# Based on TextMate's AppleScript grammar

# Detection
hook global BufCreate .*\.(applescript|scpt)$ %{
    set-option buffer filetype applescript
}

hook global BufCreate .* %{
    try %{
        execute-keys -draft %{%s\A#!.*osascript<ret>}
        set-option buffer filetype applescript
    }
}

hook -group applescript-highlight global WinSetOption filetype=applescript %{
    require-module applescript

    add-highlighter window/applescript ref applescript
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/applescript }
}

provide-module applescript %§

# Highlighters
add-highlighter shared/applescript regions
add-highlighter shared/applescript/code default-region group
add-highlighter shared/applescript/string region '"' '(?<!\\)(?:\\\\)*"' fill string
add-highlighter shared/applescript/comment_line region '--' '$' fill comment
add-highlighter shared/applescript/comment_block region '\(\*' '\*\)' fill comment
add-highlighter shared/applescript/shebang region '^#!' '$' fill comment

# Keywords and control flow
add-highlighter shared/applescript/code/keywords regex '\b(script|property|prop|end|to|on|tell|if|then|else|else if|repeat|until|while|with|from|by|in|times|exit|return|continue|try|error|considering|ignoring|but|global|local|set|copy|get|run|using terms from|timeout|transaction)\b' 0:keyword
add-highlighter shared/applescript/code/control regex '\b(return|exit|continue)\b' 0:keyword

# Simple values
add-highlighter shared/applescript/code/boolean regex '\b(true|false|yes|no)\b' 0:value
add-highlighter shared/applescript/code/null regex '\b(null|missing value)\b' 0:value
add-highlighter shared/applescript/code/numbers regex '-?\b\d+(\.\d+)?\b' 0:value

# Classes and types
add-highlighter shared/applescript/code/classes regex '\b(application|boolean|character|constant|date|file|handler|integer|list|number|record|string|text)\b' 0:type

# Built-in functions and commands
add-highlighter shared/applescript/code/builtin regex '\b(activate|log|get|set|run|count|launch|delay|display|say)\b' 0:function
add-highlighter shared/applescript/code/commands regex '\b(do shell script|beep|choose file|open location)\b' 0:function

# Operators and punctuation
add-highlighter shared/applescript/code/operators regex '(\+|-|\*|/|÷|\^|&|=|≠|>|<|≥|>=|≤|<=|and|or|\bnot\b|div|mod|as|contains)' 0:operator
add-highlighter shared/applescript/code/punctuation regex '[:\(\)]' 0:operator

§
