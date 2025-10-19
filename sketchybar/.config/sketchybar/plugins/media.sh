#!/bin/bash

YOUTUBE_PWA_PROCESS="YouTube Music"

STATE="$(echo "$INFO" | jq -r '.state')"
MEDIA="$(echo "$INFO" | jq -r '.title + "  " + .artist')"
APP="$(echo "$INFO" | jq -r '.app')"

BLACKLISTED_APPS=("Arc" "Google Chrome" "Safari" "Firefox")

is_blacklisted() {
    for blacklisted_app in "${BLACKLISTED_APPS[@]}"; do
        if [ "$APP" = "$blacklisted_app" ]; then
            return 0
        fi
    done
    return 1
}

if [ "$STATE" = "playing" ] && ! is_blacklisted; then
    sketchybar --set "$NAME" \
        label="$MEDIA" \
        label.drawing=on \
        label.max_chars=40 \
        scroll_texts=on \
        icon.color=0xffffffff \
        background.color=0xffa6da95
else
    sketchybar --set "$NAME" \
        label.drawing=off \
        icon.color=0xffeed49f \
        background.color=0x44eed49f
fi

case "$SENDER" in
"mouse.clicked")
    if pgrep -x "Spotify" >/dev/null; then
        osascript -e 'tell application "Spotify" to playpause'
    elif pgrep -f "$YOUTUBE_PWA_PROCESS" >/dev/null; then
        osascript -e 'tell application "YouTube Music" to playpause'
    elif pgrep -x "Music" >/dev/null; then
        osascript -e 'tell application "Music" to playpause'
    fi
    ;;
esac