hook global BufCreate .*[.]ejs %{
 set-option buffer filetype embedded-template
 set buffer tree_sitter_lang 'embedded-template'
}
