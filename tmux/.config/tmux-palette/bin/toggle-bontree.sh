#!/usr/bin/env bash
set -euo pipefail

current_pane="${TMUX_PANE:-}"
if [ -z "$current_pane" ]; then
  current_pane=$(tmux display-message -p '#{pane_id}')
fi

current_window=$(tmux display-message -p -t "$current_pane" '#{window_id}')
current_path=$(tmux display-message -p -t "$current_pane" '#{pane_current_path}')

bontree_pane=$(
  tmux list-panes -a -F '#{pane_id}|#{window_id}|#{pane_current_command}|#{pane_title}' |
    awk -F'|' -v current="$current_pane" -v win="$current_window" '
      $1 != current && $2 == win && ($3 == "bontree" || $4 ~ /^bontree/) {
        print $1
        exit
      }
    '
)

if [ -n "$bontree_pane" ]; then
  tmux select-pane -t "$bontree_pane"
  exit 0
fi

tmux split-window -hb -l 23% -c "$current_path" "bontree \"$current_path\""
