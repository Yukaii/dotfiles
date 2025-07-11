# debug
# set global lsp_cmd "kak-lsp -s %val{session} -vvvv --log /tmp/kak-lsp.log"
# set global lsp_debug true

# kak-lsp
hook global WinSetOption filetype=(rust|python|go|javascript|typescript|css|scss|json|markdown|toml|gleam|sh|yaml|dockerfile|vue|elixir|crystal|zig) %{
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

declare-option -hidden str lsp_server_typos %{
  [typos-lsp]
  root_globs = [".git", ".hg"]
}

declare-option -hidden str lsp_server_simple_completion %{
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

declare-option -hidden str lsp_server_ai_lsp %{
    [lsp-ai]
    settings_section = "_"
    root_globs = [".git", ".hg"]

    [lsp-ai.settings._.memory]
    file_store = { }

    [lsp-ai.settings._.models.model1]
    type = "open_ai"
    chat_endpoint = "https://api.openai.com/v1/chat/completions"
    model =  "gpt-4o-mini"
    auth_token_env_var_name = "OPENAI_API_KEY"

    [lsp-ai.settings._.completion]
    model = "model1"

    [lsp-ai.settings._.completion.parameters]
    max_tokens = 64
    max_context = 4096

    ## Configure the messages per your needs
    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "system"
    content = "Instructions:\n- You are an AI programming assistant.\n- Given a piece of code with the cursor location marked by \"<CURSOR>\", replace \"<CURSOR>\" with the correct code or comment.\n- First, think step-by-step.\n- Describe your plan for what to build in pseudocode, written out in great detail.\n- Then output the code replacing the \"<CURSOR>\"\n- Ensure that your completion fits within the language context of the provided code snippet (e.g., Python, JavaScript, Rust).\n\nRules:\n- Only respond with code or comments.\n- Only replace \"<CURSOR>\"; do not include any previously written code.\n- Never include \"<CURSOR>\" in your response\n- If the cursor is within a comment, complete the comment meaningfully.\n- Handle ambiguous cases by providing the most contextually appropriate completion.\n- Be consistent with your responses."

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "user"
    content = "def greet(name):\n    print(f\"Hello, {<CURSOR>}\")"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "assistant"
    content = "name"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "user"
    content = "function sum(a, b) {\n    return a + <CURSOR>;\n}"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "assistant"
    content = "b"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "user"
    content = "fn multiply(a: i32, b: i32) -> i32 {\n    a * <CURSOR>\n}"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "assistant"
    content = "b"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "user"
    content = "# <CURSOR>\ndef add(a, b):\n    return a + b"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "assistant"
    content = "Adds two numbers"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "user"
    content = "# This function checks if a number is even\n<CURSOR>"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "assistant"
    content = "def is_even(n):\n    return n % 2 == 0"

    [[lsp-ai.settings._.completion.parameters.messages]]
    role = "user"
    content = "{CODE}"
}

declare-option -hidden str lsp_server_copilot_lsp %{
  [copilot-language-server]
  settings_section = "_"
  args = ["--stdio"]
  root_globs = [".git", ".hg"]
}

declare-option -hidden str lsp_server_harper_lsp %{
  [harper-ls]
  settings_section = "_"
  args = ["--stdio"]
  root_globs = [".git", ".hg"]
}

# [ast-grep]
# root_globs = ["sgconfig.yml"]
# args = ["lsp"]


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

    %opt{lsp_server_typos}
    %opt{lsp_server_simple_completion}
    %opt{lsp_server_biome}
  }
}

hook -group lsp-filetype-markdown global BufSetOption filetype=markdown %{
  set-option buffer lsp_servers %exp{
    [marksman]
    root_globs = [".marksman.toml", ".git", ".obsidian", ".hg"]
    args = ["server"]

    [markdown-oxide]
    root_globs = [".git", ".hg", ".obsidian"]

    [typos-lsp]
    root_globs = [".git", ".hg"]

    %opt{lsp_server_simple_completion}
    # %opt{lsp_server_ai_lsp}
    %opt{lsp_server_copilot_lsp}

    %opt{lsp_server_harper_lsp}
  }
}

hook -group lsp-filetype-gleam global BufSetOption filetype=(?:gleam) %{
  set-option buffer lsp_servers %exp{
    [gleam]
    root_globs = ["gleam.toml", "manifest.toml"]
    args = ["lsp"]
  }
}

hook -group lsp-filetype-dockerfile global BufSetOption filetype=(?:dockerfile) %{
  set-option buffer lsp_servers %exp{
    [docker-langserver]
    root_globs = [".git", ".hg"]
    args = ["--stdio"]
  }
}


hook -group lsp-filetype-vue global BufSetOption filetype=(?:vue) %{
  set-option buffer lsp_servers %exp{
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
    %opt{lsp_str}
  }
}

hook -group lsp-filetype-vue global BufSetOption filetype=(?:elixir) %{
  set-option buffer lsp_servers %exp{
    [elixir-ls]
    root_globs = ["mix.exs", "mix.lock"]
  }
}

hook -group lsp-filetype-crystal global BufSetOption filetype=crystal %{
    set-option buffer lsp_servers %{
        [crystalline]
        args = ["--stdio"]
        root_globs = ["shard.yml"]
    }
}

hook -group lsp-filetype-zig global BufSetOption filetype=zig %{
  set-option buffer lsp_servers %{
      [zls]
      root_globs = [".git", "build.zig"]
  }
}
