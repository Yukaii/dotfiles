# Store bookmarks as a list of "file:line:col:description" entries
declare-option str-list bookmarks
declare-option str bookmarks_state_file

# Line specifications for gutter highlighting
declare-option line-specs bookmark_highlights

# Initialize state directory
define-command bookmarks-init %{
  nop %sh{
    mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/kak/bookmarks"
  }
}

# Update bookmark highlights for current buffer
define-command -hidden highlight_bookmarks %{
  evaluate-commands %sh{
    specs_list=""

    eval set -- "$kak_quoted_opt_bookmarks"
    while [ $# -gt 0 ]; do
      bookmark="$1"
      file="${bookmark%%:*}"
      rest="${bookmark#*:}"
      line="${rest%%:*}"

      # Clean quotes from parsed fields
      file="${file#\'}"
      file="${file%\'}"
      line="${line#\'}"
      line="${line%\'}"

      # Only highlight bookmarks for current buffer
      if [ "$file" = "$kak_buffile" ]; then
        specs_list="$specs_list '${line}|{blue+b}📌'"
      fi

      shift
    done

    # Apply bookmark highlights
    if [ -n "$specs_list" ]; then
      echo "set-option window bookmark_highlights %val{timestamp}$specs_list"
    else
      echo "set-option window bookmark_highlights %val{timestamp}"
    fi
  }
}

# Add current position to bookmarks
define-command bookmarks-add -params ..1 -docstring "bookmarks-add [description]: Add current position to bookmarks" %{
  evaluate-commands %sh{
    description="${1:-}"
    new_bookmark="${kak_buffile}:${kak_cursor_line}:${kak_cursor_column}:${description}"

    # Check if position already exists
    eval set -- "$kak_quoted_opt_bookmarks"
    while [ $# -gt 0 ]; do
      if [ "$1" = "$new_bookmark" ]; then
        echo "fail %{Position already bookmarked}"
        exit
      fi
      shift
    done
    printf "%s\\n" "
      set-option -add global bookmarks %{$new_bookmark}
      echo -markup {green}✓ Added bookmark${description:+: ${description}}
      highlight_bookmarks
    "
  }
}

# Navigate to bookmark at index
define-command bookmarks-nav -params 1 -docstring "bookmarks-nav <index>: Navigate to bookmark at <index>" %{
  evaluate-commands %sh{
    index=$1
    eval set -- "$kak_quoted_opt_bookmarks"
    eval "bookmark=\${$index}"
    if [ -n "$bookmark" ]; then
      file="${bookmark%%:*}"
      rest="${bookmark#*:}"
      line="${rest%%:*}"
      rest="${rest#*:}"
      col="${rest%%:*}"
      desc="${rest#*:}"
      echo "edit -existing '$file' $line $col"
      echo "echo -markup {green}[$index${desc:+: $desc}] $file:$line:$col"
    else
      echo "fail 'No bookmark at index $index'"
    fi
  }
}

# Show bookmarks list
define-command bookmarks-show-list -docstring "Show all bookmarks in the *bookmarks* buffer" %{
  evaluate-commands -save-regs dquote %{
    try %{
      edit -scratch *bookmarks*
      # Clear buffer first
      execute-keys '%d'
      # Insert bookmarks
      evaluate-commands %sh{
        eval set -- "$kak_quoted_opt_bookmarks"
        index=1
        commands=""
        while [ $# -gt 0 ]; do
          printf "execute-keys -draft 'i%d: %s<ret>'\n" "$index" "$1"
          index=$((index + 1))
          shift
        done
      }
      # Remove the last newline if buffer is not empty
      try %{ execute-keys -draft 'ged' }
      execute-keys 'gg'
    } catch %{
      delete-buffer *bookmarks*
      fail "No bookmarks are set"
    }
  }
}

# Update bookmarks from list buffer
define-command -hidden bookmarks-update-from-list %{
  evaluate-commands -save-regs dquote %{
    try %{
      # Select all lines starting with digits and colon, then select after the prefix
      execute-keys -draft -save-regs '' '%<a-s><a-k>^\d+:\s*<ret><a-;>;wl<a-l>y'
      set-option global bookmarks %reg{dquote}
      bookmarks-show-list
      highlight_bookmarks
    } catch %{
      set-option global bookmarks
    }
    echo "Updated bookmarks"
  }
}

# State saving functionality
define-command -hidden bookmarks-load %{
  evaluate-commands %sh{
    if [ -f "$kak_opt_bookmarks_state_file" ]; then
      printf "set-option global bookmarks "
      cat "$kak_opt_bookmarks_state_file"
      printf "\nhighlight_bookmarks\n"
    fi
  }
}

define-command -hidden bookmarks-save %{
  evaluate-commands %sh{
    if [ -z "$kak_opt_bookmarks_state_file" ]; then
      exit
    fi
    if [ -z "$kak_quoted_opt_bookmarks" ]; then
      rm -f "$kak_opt_bookmarks_state_file"
      exit
    fi
    printf "%s" "$kak_quoted_opt_bookmarks" > "$kak_opt_bookmarks_state_file"
  }
}

define-command -hidden bookmarks-check %{
  evaluate-commands %sh{
    if [ -z "${kak_buffile%\**\*}" ]; then
      exit
    fi
    git_branch=$(git -C "${kak_buffile%/*}" rev-parse --abbrev-ref HEAD 2>/dev/null)
    state_file=$(printf "%s" "$PWD-$git_branch" | sed -e 's|_|__|g' -e 's|/|_-|g')
    state_dir=${XDG_STATE_HOME:-~/.local/state}/kak/bookmarks
    state_path="$state_dir/$state_file"
    if [ "$state_path" != "$kak_opt_bookmarks_state_file" ]; then
      mkdir -p "$state_dir"
      printf "%s\\n" "
        bookmarks-save
        set-option global bookmarks_state_file '$state_path'
        bookmarks-load
      "
    fi
  }
}

# Default key bindings
define-command bookmarks-add-bindings -docstring "Add convenient keybindings for bookmarks" %{
  map global user b ":bookmarks-add<ret>" -docstring "add bookmark"
  map global user B ":bookmarks-show-list<ret>" -docstring "show bookmarks"

  map global normal <a-1> ":bookmarks-nav 1<ret>"
  map global normal <a-2> ":bookmarks-nav 2<ret>"
  map global normal <a-3> ":bookmarks-nav 3<ret>"
  map global normal <a-4> ":bookmarks-nav 4<ret>"
  map global normal <a-5> ":bookmarks-nav 5<ret>"
  map global normal <a-6> ":bookmarks-nav 6<ret>"
  map global normal <a-7> ":bookmarks-nav 7<ret>"
  map global normal <a-8> ":bookmarks-nav 8<ret>"
  map global normal <a-9> ":bookmarks-nav 9<ret>"
}

# Buffer-specific settings for bookmarks list
hook global BufCreate \*bookmarks\* %{
  map buffer normal <ret> ':bookmarks-nav %val{cursor_line}<ret>'
  map buffer normal <esc> ':delete-buffer *bookmarks*<ret>'
  alias buffer write bookmarks-update-from-list
  alias buffer w bookmarks-update-from-list
  add-highlighter buffer/bookmark-indices regex ^\d+: 0:function
  add-highlighter buffer/bookmark-file regex ^\d+:\s*([^:]+) 1:green
  add-highlighter buffer/bookmark-pos regex :(\d+):(\d+) 1:yellow 2:yellow
  add-highlighter buffer/bookmark-desc regex :([^:]+)$ 1:blue
}

# Gutter highlighting hook
hook global WinDisplay .* %{
  highlight_bookmarks
  add-highlighter -override window/bookmark_highlights flag-lines default bookmark_highlights
}

# Auto-save hooks
hook global FocusIn .* bookmarks-check
hook global WinDisplay .* bookmarks-check
hook global KakEnd .* bookmarks-save
