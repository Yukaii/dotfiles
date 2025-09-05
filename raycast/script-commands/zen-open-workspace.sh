#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Open Zen Workspace
# @raycast.mode silent
# @raycast.packageName Zen Browser
# @raycast.icon 🌐
# @raycast.argument1 { "type": "text", "placeholder": "Workspace (1-9)", "optional": false }
# @raycast.description Open Zen (open -a) then send Ctrl+<number> via sendkeys.

set -euo pipefail

notify() {
  /usr/bin/osascript -e 'display notification '"$1"' with title "Open Zen Workspace"' >/dev/null 2>&1 || true
}

ws=${1:-}
if [[ -z "${ws}" ]]; then
  notify "Missing workspace number"
  exit 1
fi

if ! [[ "${ws}" =~ ^[1-9]$ ]]; then
  notify "Workspace must be 1–9"
  exit 1
fi

# Prefer sendkeys for speed; ensure it's installed
if ! command -v /opt/homebrew/bin/sendkeys >/dev/null 2>&1; then
  notify "sendkeys not installed"
  echo "Error: sendkeys is not installed. Install with: brew install socsieng/tap/sendkeys" >&2
  exit 1
fi

# Bring Zen to front quickly using open -a
app_name="Zen"
open -a "Zen Browser" 2>/dev/null || true

# Small nudge to let the app focus. If desktop change it takes longer
sleep 0.5

keyseq="<c:${ws}:control>"

# Send keys to the chosen app name; avoid extra activation for speed
if ! /opt/homebrew/bin/sendkeys --application-name "$app_name" --targeted --no-activate --initial-delay 0 --delay 0 --characters "${keyseq}"; then
  notify "Failed to send keys to ${app_name}"
  exit 1
fi
