#!/bin/sh

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.color=0xff89b4fa \
                           icon.color=0xff1e1e2e \
                           background.border_width=0
else
  sketchybar --set "$NAME" background.color=0x00000000 \
                           icon.color=0xffffffff \
                           background.border_width=1
fi
