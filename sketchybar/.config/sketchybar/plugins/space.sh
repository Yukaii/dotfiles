#!/bin/sh

# The $SELECTED variable indicates if this space is currently selected
# $SID contains the space ID, $DID contains the display ID

if [ "$SELECTED" = "true" ]; then
  # Active space: solid background with dark text
  sketchybar --set "$NAME" background.color=0xff8aadf4 \
                           icon.color=0xff24273a \
                           background.border_width=0
else
  # Inactive space: transparent background with border
  sketchybar --set "$NAME" background.color=0x00000000 \
                           icon.color=0xffcad3f5 \
                           background.border_width=1
fi
