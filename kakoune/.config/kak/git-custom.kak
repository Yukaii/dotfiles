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
    If inside a diff, show the file at commit time,
    Else behave like git-jump
} %{ evaluate-commands %{
    try %{
        # Try to detect if we're in a diff section
        execute-keys -draft '<a-i>p<a-k>^diff<ret>'
        echo -debug "git-jump-at-commit: Found diff section"

        evaluate-commands -draft %{
            # Go to start of buffer to find commit info
            execute-keys 'gg'
            execute-keys '/^commit [a-f0-9]+<ret>'
            execute-keys 'xs^commit ([a-f0-9]+)<ret>'
            set-register h %reg{1}
            echo -debug "git-jump-at-commit: Commit hash: %reg{1}"

            # Find filename in current paragraph
            execute-keys '<a-i>p'
            execute-keys '/^diff --git<ret>'
            execute-keys 'xs^diff --git a/(.*) b/.*$<ret>'
            set-register f %reg{1}
            echo -debug "git-jump-at-commit: Filename: %reg{1}"
        }

        # Save file content at commit to temp file and open it
        nop %sh{
            tmp_dir="${TMPDIR:-/tmp}/kakoune-git-show"
            mkdir -p "$tmp_dir"
            # Get git root directory
            git_root=$(git rev-parse --show-toplevel)
            # Keep the full path structure under temp dir
            rel_path="${kak_reg_f#$git_root/}"
            tmp_file="$tmp_dir/$rel_path"
            tmp_dir_path=$(dirname "$tmp_file")
            mkdir -p "$tmp_dir_path"

            if git show "${kak_reg_h}:${kak_reg_f}" > "$tmp_file" 2>/dev/null; then
                printf "edit! -existing '%s'" "$tmp_file" > "$kak_command_fifo"
            else
                printf "fail 'git-jump-at-commit: Failed to show file at commit'" > "$kak_command_fifo"
            fi
        }
    } catch %{
        git-jump
    }
}}

map global custom-git-actions p ':git-pr-diff<ret>' -docstring "PR diff against base branch"
map global custom-git-actions l ':git-file-logs<ret>' -docstring "Git logs against buffer file"
map global custom-git-actions j ':git-jump-at-commit<ret>' -docstring "Jump to file at commit time"

