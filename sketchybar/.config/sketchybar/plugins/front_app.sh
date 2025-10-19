#!/usr/bin/env zsh

if [ "$SENDER" = "front_app_switched" ]; then
    # Get icon from icon map
    icon=$("$HOME/.config/sketchybar/plugins/icon_map.sh" "$INFO")

    # Set the icon and update the app name
    sketchybar --set $NAME icon="$icon" \
               --set $NAME.name label="$INFO"
fi
