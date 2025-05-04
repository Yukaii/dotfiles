#!/usr/bin/env bash
# switch_edge.sh — switch Edge profile or workspace via keyboard shortcut
# Supports stable (default), Dev (--dev), and Canary (--canary) editions.

set -e

usage() {
  cat <<USAGE
Usage: $0 [--dev|--canary] (--profile <name> | --workspace <name>) [--en|--jp]

  --dev           target Microsoft Edge Dev
  --canary        target Microsoft Edge Canary
  --profile NAME  switch to profile NAME
  --workspace NAME switch to workspace NAME
  --en            use English menus (default)
  --jp            use Japanese menus
USAGE
  exit 1
}

# defaults
edition="stable"
lang="en"
profile=""
workspace=""

# parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dev)    edition="dev"; shift ;;
    --canary) edition="canary"; shift ;;
    --profile)
      [[ -n "$workspace" ]] && usage
      profile="$2"; shift 2 ;;
    --workspace)
      [[ -n "$profile" ]] && usage
      workspace="$2"; shift 2 ;;
    --en|--jp)
      lang="${1/--/}"; shift ;;
    *)
      usage ;;
  esac
done

# validate
if [[ -z "$profile" && -z "$workspace" ]]; then
  usage
fi

# map edition to app/process name
case "$edition" in
  stable)  appName="Microsoft Edge";;
  dev)     appName="Microsoft Edge Dev";;
  canary)  appName="Microsoft Edge Canary";;
esac

# localized menu labels
if [[ "$lang" == "jp" ]]; then
  MENU_PROFILE="プロファイル"
  MENU_WINDOW="ウィンドウ"
else
  MENU_PROFILE="Profile"
  MENU_WINDOW="Window"
fi

# choose menu and target
if [[ -n "$profile" ]]; then
  menuBar="$MENU_PROFILE"
  target="$profile"
else
  menuBar="$MENU_WINDOW"
  target="$workspace"
fi

# invoke AppleScript
osascript <<EOF
tell application "$appName" to activate
tell application "System Events"
  tell process "$appName"
    click menu item "$target" of menu 1 of menu bar item "$menuBar" of menu bar 1
  end tell
end tell
EOF
