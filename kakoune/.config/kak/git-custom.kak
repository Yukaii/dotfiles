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

      # Extract commit hash
      evaluate-commands -draft %{
        execute-keys 'gg'
        execute-keys '/^commit [a-f0-9]+<ret>'
        execute-keys 'xs^commit ([a-f0-9]+)<ret>'
        set-register h %reg{1}
      }

      # Extract filename
      evaluate-commands -draft %{
        execute-keys '<a-?>^diff --git<ret>'
        execute-keys ';xs^diff --git a/(.*) b/.*$<ret>'
        set-register f %reg{1}
      }

      # Try to find the line number from hunk header and current position
      evaluate-commands -draft %{
        try %{
          # Find previous hunk header
          execute-keys '<a-?>^@@.*?@@<ret>'
          # Extract start line number from hunk header
          execute-keys 'xs^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@.*$<ret>'
          set-register s %reg{1}  # Save start line

          # Select content between hunk header and cursor position
          execute-keys '<a-_>'

          # Calculate actual line number
          set-register l %sh{
            start_line=$kak_reg_s
            current_pos=${kak_cursor_line}
            hunk_start=$(echo "${kak_selection_desc}" | cut -d'.' -f1)

            # Get the content between hunk start and cursor
            content=$(printf '%s\n' "${kak_selection}")
            # Count added/removed lines
            added_lines=$(printf '%s\n' "$content" | grep -c '^+')
            removed_lines=$(printf '%s\n' "$content" | grep -c '^-')

            # Adjust relative position by removing the effect of diff markers
            rel_lines=$((current_pos - hunk_start - removed_lines))
            final_line=$((start_line + rel_lines - 1))

            echo $final_line
          }
        }
      }

    # Save file content at commit to temp file and open it
    nop %sh{
      # Create unique hash from repo path and commit
      repo_path=$(git rev-parse --show-toplevel)
      repo_hash=$(echo "$repo_path" | sha256sum | cut -c1-8)
      tmp_dir="${TMPDIR:-/tmp}/kakoune-git-show/$repo_hash/${kak_reg_h}"
      mkdir -p "$tmp_dir"

      # Create temp directory structure matching original path
      tmp_file="$tmp_dir/${kak_reg_f}"
      tmp_dir_path=$(dirname "$tmp_file")
      mkdir -p "$tmp_dir_path"

      # Try to show file content at commit
      if git show "${kak_reg_h}:${kak_reg_f}" > "$tmp_file" 2>/dev/null; then
        if [ -n "${kak_reg_l}" ]; then
          printf "edit! -existing '%s'; execute-keys '%sg'" "$tmp_file" "${kak_reg_l}" > "$kak_command_fifo"
        else
          printf "edit! -existing '%s'" "$tmp_file" > "$kak_command_fifo"
        fi
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
