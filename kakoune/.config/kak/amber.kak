# Author: GPT-4o
# amber language support for Kakoune

# Detection
hook global BufCreate .*\.amber %{
    set-option buffer filetype amber
}

hook -group amber-highlight global WinSetOption filetype=amber %{
    require-module amber

    add-highlighter window/amber ref amber
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/amber }
}

provide-module amber %§
    # Highlighters
    add-highlighter shared/amber regions
    add-highlighter shared/amber/code default-region group

    # Comments
    add-highlighter shared/amber/comment-line region '//' '\n' fill comment
    add-highlighter shared/amber/comment-block region '/*' '*/' fill comment
    add-highlighter shared/amber/comment region '#'  '$' fill comment

    # Keywords
    add-highlighter shared/amber/code/keyword-control regex '\b(if|loop|ref|return|fun|else|then|break|continue|and|or|not|let|import|from|pub|main|echo|as|in|fail|failed|status|silent|nameof|is|unsafe)\b' 0:keyword
    add-highlighter shared/amber/code/boolean regex '\b(true|false|null)\b(?![?!])' 0:boolean

    # Function definitions
    add-highlighter shared/amber/code/function-def regex '(fun)\s+(\w[^(\n]+)' 1:keyword 2:function

    # Class names
    add-highlighter shared/amber/code/class regex '\b[A-Z][a-z0-9_]*\b' 0:type

    # Function calls
    add-highlighter shared/amber/code/function-call regex '\b\w+\s*(?=\()' 0:function

    # Constants
    add-highlighter shared/amber/code/constant regex '\b[+-]?([0-9]*[.])?[0-9]+\b' 0:number

    # Operators
    add-highlighter shared/amber/code/operator regex '\+|\-|\^|\*|=|\||%|!|>|<|\.{2}|\?' 0:operator

    # Variables
    add-highlighter shared/amber/code/variable regex '\b\w+\b' 0:variable

    # Strings
    add-highlighter shared/amber/string region '"' '(?<!\\)(?:\\\\)*"' fill string
    add-highlighter shared/amber/string/escape regex '\\\\.' 0:escape
    add-highlighter shared/amber/string/interpolated begin '\{' end '\}' recurse

    # Command
    add-highlighter shared/amber/command region '\$' '\$' fill variable
    add-highlighter shared/amber/command/escape regex '\\\\.' 0:escape
    add-highlighter shared/amber/command/parameter regex '-{1,2}[A-Za-z0-9-_]+' 0:parameter
    add-highlighter shared/amber/command/other regex '[A-Za-z0-9-_]+' 0:variable
    add-highlighter shared/amber/command/interpolated begin '\{' end '\}' recurse
§

