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
      }

      evaluate-commands -draft %{
        # Find filename in current paragraph
        execute-keys '<a-?>^diff --git<ret>'
        execute-keys ';xs^diff --git a/(.*) b/.*$<ret>'
        set-register f %reg{1}
        echo -debug "git-jump-at-commit: Filename: %reg{1}"
      }

      evaluate-commands -draft %{
        # Try to find the line number from hunk header and current position
        try %{
          echo -debug "git-jump-at-commit: Trying to find hunk header..."
          execute-keys '<a-?>^@@.*?@@<ret>'  # Find previous hunk header
          echo -debug "git-jump-at-commit: Found hunk header"
          execute-keys 'xs^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@.*$<ret>'  # Extract start line
          echo -debug "git-jump-at-commit: Extracted line number pattern"
          set-register s %reg{1}  # Save start line
          echo -debug "git-jump-at-commit: Hunk start line: %reg{1}"

          execute-keys '<a-_>'
          set-register l %sh{
            # Calculate actual line number, accounting for diff +/- lines
            start_line=$kak_reg_s
            current_pos=${kak_cursor_line}
            # Extract just the integer part of the line number
            hunk_start=$(echo "${kak_selection_desc}" | cut -d'.' -f1)

            echo "DEBUG: start_line=$start_line" >&2
            echo "DEBUG: current_pos=$current_pos" >&2
            echo "DEBUG: hunk_start=$hunk_start" >&2

            # Get the content between hunk start and cursor
            content=$(printf '%s\n' "${kak_selection}")
            # Count added/removed lines
            added_lines=$(printf '%s\n' "$content" | grep -c '^+')
            removed_lines=$(printf '%s\n' "$content" | grep -c '^-')

            echo "DEBUG: added_lines=$added_lines" >&2
            echo "DEBUG: removed_lines=$removed_lines" >&2

            # Adjust relative position by removing the effect of diff markers
            rel_lines=$((current_pos - hunk_start - removed_lines))
            final_line=$((start_line + rel_lines - 1))

            echo "DEBUG: rel_lines=$rel_lines" >&2
            echo "DEBUG: final_line=$final_line" >&2

            echo $final_line
          }
          echo -debug "git-jump-at-commit: Target line: %reg{l}"
        }
      }

    # Save file content at commit to temp file and open it
    nop %sh{
      tmp_dir="${TMPDIR:-/tmp}/kakoune-git-show"
      mkdir -p "$tmp_dir"
      # Create temp directory structure
      tmp_file="$tmp_dir/${kak_reg_f##*/}"
      mkdir -p "$tmp_dir"

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
