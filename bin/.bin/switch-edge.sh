#!/usr/bin/env bash
# switch_edge.sh — switch Edge profile or workspace via keyboard shortcut
# Supports stable (default), Dev (--dev), Canary (--canary),
# English/Japanese menus, and fuzzy-matching (ignores trailing emojis).

set -e

usage(){
  cat <<USAGE
Usage: $0 [--dev|--canary] (--profile <name> | --workspace <name>) [--en|--jp]

  --dev             target Microsoft Edge Dev
  --canary          target Microsoft Edge Canary
  --profile NAME    switch to profile matching NAME
  --workspace NAME  switch to workspace matching NAME
  --en              use English menus (default)
  --jp              use Japanese menus
USAGE
  exit 1
}

# defaults
edition="stable"; lang="en"; profile=""; workspace=""

# parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --dev)     edition="dev"; shift;;
    --canary)  edition="canary"; shift;;
    --profile) [[ -n $workspace ]] && usage; profile="$2"; shift 2;;
    --workspace) [[ -n $profile ]] && usage; workspace="$2"; shift 2;;
    --en|--jp) lang="${1/--/}"; shift;;
    *)         usage;;
  esac
done

[[ -z $profile && -z $workspace ]] && usage

# map edition→app name
case $edition in
  stable) app="Microsoft Edge";;
  dev)    app="Microsoft Edge Dev";;
  canary) app="Microsoft Edge Canary";;
esac

# localize menu titles
if [[ $lang == "jp" ]]; then
  M_PROFILE="プロファイル"; M_WINDOW="ウィンドウ"
else
  M_PROFILE="Profile";    M_WINDOW="Window"
fi

# pick which to click
if [[ -n $profile ]]; then
  MENU_BAR_ITEM="$M_PROFILE"
  TARGET="$profile"
else
  MENU_BAR_ITEM="$M_WINDOW"
  TARGET="$workspace"
fi

# AppleScript: find & click the FIRST menu item whose name contains TARGET
osascript <<EOF
tell application "System Events"
  tell process "$app"
    set theMenu to menu 1 of menu bar item "$MENU_BAR_ITEM" of menu bar 1
    click (first menu item of theMenu whose name contains "$TARGET")
  end tell
end tell
EOF
