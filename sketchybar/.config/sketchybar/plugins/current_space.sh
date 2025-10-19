#!/usr/bin/env zsh

update_space() {
    SPACE_ID=$(echo "$INFO" | jq -r '."display-1"')

    case $SPACE_ID in
    1)
        ICON=󰊠
        ;;
    2)
        ICON=󰈹
        ;;
    3)
        ICON=󰆍
        ;;
    4)
        ICON=󰎄
        ;;
    5)
        ICON=󰊻
        ;;
    *)
        ICON=󰊠
        ;;
    esac

    sketchybar --set $NAME icon=$ICON \
               --set space_number label="$SPACE_ID"
}

case "$SENDER" in
"mouse.clicked")
    # Reload sketchybar
    sketchybar --remove '/.*/'
    source $HOME/.config/sketchybar/sketchybarrc
    ;;
*)
    update_space
    ;;
esac
