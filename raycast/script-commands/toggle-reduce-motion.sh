#!/usr/bin/env bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Reduce Motion
# @raycast.mode silent
# Optional parameters:
# @raycast.icon 🎞️
# @raycast.packageName Accessibility
# @raycast.description Toggle the macOS Reduce Motion accessibility setting immediately.

set -euo pipefail

lang=$(defaults read NSGlobalDomain AppleLanguages 2>/dev/null | awk 'NR==1{print $1}' | tr -d '(),' || true)
lang=${lang:-en}

current=$(defaults read com.apple.universalaccess reduceMotion 2>/dev/null || echo 0)

if [ "$current" -eq 1 ]; then
  defaults write com.apple.universalaccess reduceMotion -bool false
  enabled=0
else
  defaults write com.apple.universalaccess reduceMotion -bool true
  enabled=1
fi

# Refresh UI so the change takes effect immediately
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

# Localized messaging
if [[ "$lang" == ja* ]]; then
  title="アクセシビリティ"
  if [ "$enabled" -eq 1 ]; then
    msg="視覚効果を減らすをオンにしました"
  else
    msg="視覚効果を減らすをオフにしました"
  fi
elif [[ "$lang" == zh-Hant* || "$lang" == zh-TW* || "$lang" == zh-HK* ]]; then
  title="輔助使用"
  if [ "$enabled" -eq 1 ]; then
    msg="已開啟減少動畫"
  else
    msg="已關閉減少動畫"
  fi
else
  title="Accessibility"
  if [ "$enabled" -eq 1 ]; then
    msg="Reduce motion is now ON"
  else
    msg="Reduce motion is now OFF"
  fi
fi

# Show a native notification when possible
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"$msg\" with title \"$title\"" >/dev/null 2>&1 || true
fi

echo "$msg"
