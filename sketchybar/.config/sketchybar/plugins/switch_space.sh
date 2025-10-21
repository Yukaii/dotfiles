#!/bin/bash

# Get the space number from the first argument
SPACE_NUM=$1

if [ -z "$SPACE_NUM" ]; then
    echo "Usage: $0 <space_number>"
    exit 1
fi

# Use keyboard shortcuts to directly switch spaces
# This simulates Alt (Option) + Number which matches your configured shortcuts
case $SPACE_NUM in
    1) osascript -e 'tell application "System Events" to key code 18 using option down' ;;
    2) osascript -e 'tell application "System Events" to key code 19 using option down' ;;
    3) osascript -e 'tell application "System Events" to key code 20 using option down' ;;
    4) osascript -e 'tell application "System Events" to key code 21 using option down' ;;
    5) osascript -e 'tell application "System Events" to key code 23 using option down' ;;
    6) osascript -e 'tell application "System Events" to key code 22 using option down' ;;
    7) osascript -e 'tell application "System Events" to key code 26 using option down' ;;
    8) osascript -e 'tell application "System Events" to key code 28 using option down' ;;
    9) osascript -e 'tell application "System Events" to key code 25 using option down' ;;
    10) osascript -e 'tell application "System Events" to key code 29 using option down' ;;
    *) echo "Space number $SPACE_NUM not supported" ;;
esac