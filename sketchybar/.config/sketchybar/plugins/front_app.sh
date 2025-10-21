#!/usr/bin/env zsh

if [ "$SENDER" = "front_app_switched" ]; then
    # Minimal front app display - just the app name
    sketchybar --set $NAME label="$INFO"
fi
