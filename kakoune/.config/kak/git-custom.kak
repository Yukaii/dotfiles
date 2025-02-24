declare-user-mode custom-git-actions
map global git g ':enter-user-mode custom-git-actions<ret>' -docstring "custom git actions"

define-command -params ..1 git-pr-diff -docstring %{
  Show pull request diff against the default branch or a specified base branch.
} %{
  evaluate-commands %sh{
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    compare_branch=${1:-$default_branch}
    diffBase=$(git merge-base HEAD $compare_branch)
    echo "git diff $diffBase HEAD"
  }
}

map global git P ':git-pr-diff<ret>' -docstring "PR diff against base branch"

define-command git-file-logs -docstring %{
  Show git commits of current buffer
} %{
  git-log --follow -- %val{bufname}
}

# Alternative git jump command that shows file at commit time
define-command -override git-jump-at-commit -docstring %{
    If inside a diff, show the file content at commit time,
    Else behave like git-jump
} %{ evaluate-commands %{
    try %{
        # Try to detect if we're in a diff section and store the paragraph
        execute-keys -draft '<a-i>p<a-k>^diff<ret>'
        execute-keys -draft -save-regs 'p' '<a-i>p"py'
        echo -debug "git-jump-at-commit: Found diff section"

        evaluate-commands -draft %{
            # Go to start of buffer to find commit info
            execute-keys 'gg'
            execute-keys '/^commit [a-f0-9]+<ret>'
            execute-keys 'xs^commit ([a-f0-9]+)<ret>'
            set-register h %reg{1}
            echo -debug "git-jump-at-commit: Commit hash: %reg{1}"

            # Use the stored paragraph to find filename
            execute-keys '"pR'  # Restore paragraph and select it
            execute-keys '/^diff --git<ret>'  # Find diff line
            execute-keys 'xs^diff --git a/(.*) b/.*$<ret>'  # Extract filename
            set-register f %reg{1}
            echo -debug "git-jump-at-commit: Filename: %reg{1}"
            echo -debug "git-jump-at-commit: Diff paragraph: %reg{p}"
        }

        # Show file at that commit
        evaluate-commands %sh{
            printf %s "echo -debug 'git-jump-at-commit: Running git show ${kak_reg_h}:${kak_reg_f}'; git show ${kak_reg_h}:${kak_reg_f}"
        }
    } catch %{
        echo -debug "git-jump-at-commit: Failed to parse diff"
        fail "git-jump-at-commit: Failed to parse diff"
    }
}}

map global custom-git-actions p ':git-pr-diff<ret>' -docstring "PR diff against base branch"
map global custom-git-actions l ':git-file-logs<ret>' -docstring "Git logs against buffer file"
map global custom-git-actions j ':git-jump-at-commit<ret>' -docstring "Jump to file at commit time"

