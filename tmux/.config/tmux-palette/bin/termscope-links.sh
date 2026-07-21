#!/usr/bin/env bash
set -euo pipefail

TERMSCOPE="${TERMSCOPE:-$HOME/.tmux/plugins/termscope/termscope}"
PANE_PATH="$(tmux display-message -p '#{pane_current_path}')"
PANE_ID="$(tmux display-message -p '#{pane_id}')"

tmux display-popup -E -w 80% -h 60% \
  "$TERMSCOPE" links \
  --pane-path "$PANE_PATH" \
  --pane-id "$PANE_ID"
