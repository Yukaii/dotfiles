# Yank mode for Kakoune
# Provides various yank operations for file paths, selections, etc.

declare-user-mode yank

# Yank buffer file name (without path)
define-command yank-buffer-name -docstring "yank buffer file name" %{
    set-register dquote %sh{ basename "$kak_bufname" }
    echo -markup "{Information}Yanked buffer name: %reg{dquote}"
}

# Yank full buffer path
define-command yank-buffer-path -docstring "yank full buffer path" %{
    set-register dquote %val{bufname}
    echo -markup "{Information}Yanked buffer path: %reg{dquote}"
}

# Yank directory of current buffer
define-command yank-buffer-directory -docstring "yank buffer directory" %{
    set-register dquote %sh{ dirname "$kak_bufname" }
    echo -markup "{Information}Yanked buffer directory: %reg{dquote}"
}

# Yank current working directory
define-command yank-working-directory -docstring "yank working directory" %{
    set-register dquote %sh{ echo "$kak_client_env_PWD" }
    echo -markup "{Information}Yanked working directory: %reg{dquote}"
}

# Yank current line number
define-command yank-line-number -docstring "yank current line number" %{
    set-register dquote %val{cursor_line}
    echo -markup "{Information}Yanked line number: %reg{dquote}"
}

# Yank current selection as markdown code block
define-command yank-as-markdown -docstring "yank selection as markdown code block" %{
    set-register dquote %sh{
        filetype="${kak_opt_filetype:-text}"
        printf '```%s\n%s\n```' "$filetype" "$kak_selection"
    }
    echo -markup "{Information}Yanked selection as markdown"
}

# Map commands to yank mode
map global yank b ':yank-buffer-name<ret>'       -docstring 'buffer name'
map global yank f ':yank-buffer-path<ret>'       -docstring 'full buffer path'
map global yank d ':yank-buffer-directory<ret>'  -docstring 'buffer directory'
map global yank w ':yank-working-directory<ret>' -docstring 'working directory'
map global yank l ':yank-line-number<ret>'       -docstring 'line number'
map global yank m ':yank-as-markdown<ret>'       -docstring 'as markdown'
map global yank p ':gitlinker<ret>'              -docstring 'git permalink (gitlinker)'
