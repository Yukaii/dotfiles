# debug
# set global lsp_cmd "kak-lsp -s %val{session} -vvvv --log /tmp/kak-lsp.log"
# set global lsp_debug true

# kak-lsp
hook global WinSetOption filetype=(rust|python|go|javascript|typescript|css|scss|json|markdown|toml|gleam|sh|yaml|dockerfile|vue|elixir) %{
  lsp-enable-window
}

set-face global DiagnosticTagDeprecated +s
set-face global DiagnosticTagUnnecessary dim

lsp-inlay-hints-enable       global
lsp-diagnostic-lines-enable global
lsp-inlay-diagnostics-enable global

set-option global lsp_hover_anchor false

map global lsp 'D' ':lsp-diagnostics<ret>' -docstring 'LSP diagnostics'
map global lsp 'w' ':lsp-workspace-symbol-incr<ret>' -docstring 'LSP workspace symbol'

# lsp related mappings
map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
map global object a '<a-semicolon>lsp-object<ret>'                               -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>'                           -docstring 'LSP any symbol'
map global object e '<a-semicolon>lsp-object Function Method<ret>'               -docstring 'LSP function or method'
map global object k '<a-semicolon>lsp-object Class Interface Struct<ret>'        -docstring 'LSP class interface or struct'
map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-semicolon>lsp-diagnostic-object<ret>'                    -docstring 'LSP errors'

set-option global lsp_auto_show_code_actions true

hook -group lsp-filetype-javascript global BufSetOption filetype=(?:javascript|typescript) %{
  set-option buffer lsp_servers %exp{
    [typescript-language-server]
    root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git", ".hg"]
    args = ["--stdio"]
    settings_section = "_"
    [typescript-language-server.settings._]
    # quotePreference = "double"
    # typescript.format.semicolons = "insert"

    [vscode-eslint-language-server]
    root_globs = [".eslintrc", ".eslintrc.json"]
    args = ["--stdio"]
    workaround_eslint = true
    [vscode-eslint-language-server.settings]
    nodePath = ""
    codeActionsOnSave = { mode = "all", "source.fixAll.eslint" = true }
    format = { enable = true }
    quiet = false
    rulesCustomizations = []
    run = "onType"
    validate = "on"
    experimental = {}
    problems = { shortenToSingleLine = false }
    codeAction.disableRuleComment = { enable = true, location = "separateLine" }
    codeAction.showDocumentation = { enable = false }

    [tailwindcss-language-server]
    root_globs = ["tailwind.config.ts", "tailwind.config.js"]
    args = ["--stdio"]
    settings_section = "_"
    [tailwindcss-language-server.settings._]
    editor = {}

    [typos-lsp]
    root_globs = [".git", ".hg"]

    [simple-completion-language-server]
    root_globs = [".git", ".hg"]
    [simple-completion-language-server.settings.scls]
    max_completion_items = 20            # set max completion results len for each group: words, snippets, unicode-input
    snippets_first = true                # completions will return before snippets by default
    snippets_inline_by_word_tail = false # suggest snippets by WORD tail, for example text `xsq|` become `x^2|` when snippet `sq` has body `^2`
    feature_words = true                 # enable completion by word
    feature_snippets = true              # enable snippets
    feature_unicode_input = true         # enable "unicode input"
    feature_paths = true                 # enable path completion
    feature_citations = false            # enable citation completion (only on `citation` feature enabled)

    [simple-completion-language-server.settings.environment]
    RUST_LOG = "info,simple-completion-language-server=info"
    LOG_FILE = "/tmp/completion.log"

    # [ast-grep]
    # root_globs = ["sgconfig.yml"]
    # args = ["lsp"]
    %opt{lsp_server_biome}
  }
}

hook -group lsp-filetype-markdown global BufSetOption filetype=markdown %{
  set-option buffer lsp_servers %{
    [marksman]
    root_globs = [".marksman.toml", ".git", ".obsidian", ".hg"]
    args = ["server"]

    [markdown-oxide]
    root_globs = [".git", ".hg", ".obsidian"]

    [typos-lsp]
    root_globs = [".git", ".hg"]

    [simple-completion-language-server]
    root_globs = [".git", ".hg"]
    [simple-completion-language-server.settings.scls]
    max_completion_items = 20            # set max completion results len for each group: words, snippets, unicode-input
    snippets_first = true                # completions will return before snippets by default
    snippets_inline_by_word_tail = false # suggest snippets by WORD tail, for example text `xsq|` become `x^2|` when snippet `sq` has body `^2`
    feature_words = true                 # enable completion by word
    feature_snippets = true              # enable snippets
    feature_unicode_input = true         # enable "unicode input"
    feature_paths = true                 # enable path completion
    feature_citations = false            # enable citation completion (only on `citation` feature enabled)

    [simple-completion-language-server.settings.environment]
    RUST_LOG = "info,simple-completion-language-server=info"
    LOG_FILE = "/tmp/completion.log"
  }
}

hook -group lsp-filetype-gleam global BufSetOption filetype=(?:gleam) %{
  set-option buffer lsp_servers %{
    [gleam]
    root_globs = ["gleam.toml", "manifest.toml"]
    args = ["lsp"]
  }
}

hook -group lsp-filetype-dockerfile global BufSetOption filetype=(?:dockerfile) %{
  set-option buffer lsp_servers %{
    [docker-langserver]
    root_globs = [".git", ".hg"]
    args = ["--stdio"]
  }
}


hook -group lsp-filetype-vue global BufSetOption filetype=(?:vue) %{
  set-option buffer lsp_servers %{
    [vue-language-server]
    root_globs = [".git", ".hg"]
    args = ["--stdio"]
    settings_section = "_"

    [vue-language-server.settings._]
    typescript = { tsdk = "node_modules/typescript/lib/" }

    [typescript-language-server]
    root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git", ".hg"]
    args = ["--stdio"]
    settings_section = "_"

    # https://github.com/helix-editor/helix/discussions/10349
    [[typescript-language-server.settings._.plugins]]
    name = "@vue/typescript-plugin"
    location = "/Users/yukai/.bun/install/global/node_modules/@vue/typescript-plugin"
    languages = ["javascript", "typescript", "vue"]
    # quotePreference = "double"
    # typescript.format.semicolons = "insert"
  }
}

hook -group lsp-filetype-vue global BufSetOption filetype=(?:elixir) %{
  set-option buffer lsp_servers %{
    [elixir-ls]
    root_globs = ["mix.exs", "mix.lock"]
  }
}
