define-command edir-buffer-dir -docstring 'open edir in buffer directory' %{
  evaluate-commands %sh{
    dir=$(dirname "$kak_bufname")
    echo "terminal-popup edir \"$dir\""
  }
}

# Add filetype for edir.sh output
add-highlighter shared/edir group
add-highlighter shared/edir/number regex '^\s*\d+\s+' 0:cyan
add-highlighter shared/edir/filepath regex '^\s*(?:\d+\s+)?(.*?)$' 1:default

hook global BufCreate .*edir\.sh %{
  set-option buffer filetype edir
}

hook global WinSetOption filetype=edir %{
  add-highlighter window/edir ref edir
}

