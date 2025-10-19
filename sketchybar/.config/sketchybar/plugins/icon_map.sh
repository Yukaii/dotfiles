#!/usr/bin/env bash

# Simplified icon mapping based on reference
function __icon_map() {
    case "$1" in
        "Arc") icon_result="󰞍";;
        "Code"|"Visual Studio Code") icon_result="󰨞";;
        "Cursor") icon_result="󰨞";;
        "Calendar") icon_result="";;
        "Discord") icon_result="";;
        "FaceTime") icon_result="";;
        "Finder") icon_result="󰀶";;
        "Google Chrome"|"Chromium") icon_result="";;
        "IINA") icon_result="󰕼";;
        "kitty") icon_result="󰄛";;
        "Messages") icon_result="";;
        "Notion") icon_result="󰎚";;
        "Preview") icon_result="";;
        "Spotify") icon_result="";;
        "TextEdit") icon_result="";;
        "Terminal") icon_result="";;
        "iTerm2"|"iTerm") icon_result="";;
        "Safari") icon_result="";;
        "Firefox") icon_result="";;
        "Slack") icon_result="";;
        "Zoom") icon_result="";;
        "Xcode") icon_result="";;
        "System Preferences"|"System Settings") icon_result="";;
        "Mail") icon_result="";;
        "Notes") icon_result="";;
        "Reminders") icon_result="";;
        "Music") icon_result="";;
        "Podcasts") icon_result="";;
        "Photos") icon_result="";;
        "YouTube Music") icon_result="󰐍";;
        "Stremio") icon_result="󱜠";;
        *) icon_result="";;
    esac
}

__icon_map "$1"
echo "$icon_result"