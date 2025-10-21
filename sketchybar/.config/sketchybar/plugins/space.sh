#!/bin/sh

# Minimal space styling - active spaces get subtle background
if [ "$SELECTED" = "true" ]; then
  # Active space: subtle background highlight
  sketchybar --set "$NAME" background.color=0x40FFF7ED
else
  # Inactive space: transparent background
  sketchybar --set "$NAME" background.color=0x00000000
fi
