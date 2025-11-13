declare-user-mode custom-git-actions
map global git g ':enter-user-mode custom-git-actions<ret>' -docstring "custom git actions"

declare-option -hidden bool git_diff_fifo_ready true

hook global BufCreate '\*git\*' %{
  set-option buffer git_diff_fifo_ready true
  hook -always buffer BufOpenFifo '.*' %{
    set-option buffer git_diff_fifo_ready false
  }
  hook -always buffer BufCloseFifo '.*' %{
    # Simply mark as ready - no buffer conversion needed
    # The fifo content is already complete when this hook fires
    set-option buffer git_diff_fifo_ready true
  }
}

define-command -params ..1 git-pr-diff -docstring %{
  Show pull request diff against the default branch or a specified base branch.
  Uses a static buffer to avoid content changes during navigation.
} %{
  evaluate-commands %sh{
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
    compare_branch=${1:-$default_branch}
    diffBase=$(git merge-base HEAD $compare_branch)

    # Create a temp file with the complete diff
    tmpfile=$(mktemp "${TMPDIR:-/tmp}/kak-pr-diff.XXXXXX")
    git diff $diffBase HEAD > "$tmpfile" 2>&1

    # Edit it directly instead of using fifo
    printf "edit! -scratch *git*\n"
    printf "execute-keys '%%d'\n"  # Clear buffer
    printf "execute-keys '!cat %s<ret>'\n" "$tmpfile"
    printf "set-option buffer filetype git-diff\n"
    printf "execute-keys 'gg'\n"  # Go to top
    printf "nop %%sh{ rm -f %s }\n" "$tmpfile"
  }
}

map global git P ':git-pr-diff<ret>' -docstring "PR diff against base branch"

define-command -params 1 gh-pr-diff -docstring %{
  Show the diff of a remote pull request using gh pr diff.
  Usage: gh-pr-diff <pr-number>
} %{
  evaluate-commands %sh{
    pr_number=$1

    # Create a temp file with the PR diff
    tmpfile=$(mktemp "${TMPDIR:-/tmp}/kak-gh-pr-diff.XXXXXX")

    if gh pr diff "$pr_number" > "$tmpfile" 2>&1; then
      # Edit it in a scratch buffer
      printf "edit! -scratch *gh-pr-%s*\n" "$pr_number"
      printf "execute-keys '%%d'\n"  # Clear buffer
      printf "execute-keys '!cat %s<ret>'\n" "$tmpfile"
      printf "set-option buffer filetype git-diff\n"
      printf "execute-keys 'gg'\n"  # Go to top
      printf "nop %%sh{ rm -f %s }\n" "$tmpfile"
    else
      # Show error message
      error_msg=$(cat "$tmpfile")
      printf "echo -markup '{Error}gh pr diff failed: %s'\n" "$error_msg"
      printf "nop %%sh{ rm -f %s }\n" "$tmpfile"
    fi
  }
}

define-command -hidden test-kks-cat-stability -docstring "Test if kks cat returns stable content" %{
  evaluate-commands %sh{
    (
      export KKS_SESSION="$kak_session"
      export KKS_CLIENT="$kak_client"

      bufname="$kak_bufname"

      echo "Testing kks cat stability in buffer: $bufname" > /tmp/kks-stability-test.log
      echo "Session: $kak_session, Client: $kak_client" >> /tmp/kks-stability-test.log
      echo "Starting test at $(date)..." >> /tmp/kks-stability-test.log
      echo "" >> /tmp/kks-stability-test.log

      for i in 1 2 3 4 5; do
        echo "Starting run $i..." >> /tmp/kks-stability-test.log
        # Use timeout to prevent hanging (5 second timeout)
        output=$(timeout 5 kks cat 2>&1 || echo "TIMEOUT")

        if [ "$output" = "TIMEOUT" ]; then
          echo "Run $i: TIMEOUT - kks cat hung!" >> /tmp/kks-stability-test.log
        else
          lines=$(echo "$output" | wc -l | tr -d ' ')
          files=$(echo "$output" | grep -c "^diff --git")
          md5=$(echo "$output" | md5)
          echo "Run $i: $lines lines, $files files, MD5: $md5" >> /tmp/kks-stability-test.log
        fi
        sleep 0.2
      done

      echo "" >> /tmp/kks-stability-test.log
      echo "Test finished at $(date)" >> /tmp/kks-stability-test.log
    ) &

    echo "echo -markup '{Information}Test running in background, check /tmp/kks-stability-test.log in a few seconds'"
  }
}

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
map global custom-git-actions r ':gh-pr-diff ' -docstring "Remote PR diff (gh pr diff)"
map global custom-git-actions l ':git-file-logs<ret>' -docstring "Git logs against buffer file"
map global custom-git-actions j ':git-jump-at-commit<ret>' -docstring "Jump to file at commit time"
