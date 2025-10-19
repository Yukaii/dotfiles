#!/usr/bin/env zsh

if [ "$SENDER" = "spotify_change" ]; then
    if pgrep -x "Spotify" > /dev/null; then
        PLAYING=$(osascript -e 'tell application "Spotify" to player state as string')

        if [ "$PLAYING" = "playing" ]; then
            TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string')
            ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string')

            sketchybar --set "$NAME" \
                label="${TRACK} - ${ARTIST}" \
                label.drawing=on \
                label.max_chars=35 \
                scroll_texts=on \
                background.color=0xffa6da95 \
                icon.color=0xff181926
        else
            sketchybar --set "$NAME" \
                label.drawing=off \
                background.color=0x44a6da95 \
                icon.color=0xffa6da95
        fi
    else
        sketchybar --set "$NAME" \
            label.drawing=off \
            background.color=0x44a6da95 \
            icon.color=0xffa6da95
    fi
fi

case "$SENDER" in
"mouse.clicked")
    if pgrep -x "Spotify" > /dev/null; then
        osascript -e 'tell application "Spotify" to playpause'
    else
        open -a "Spotify"
    fi
    ;;
esac