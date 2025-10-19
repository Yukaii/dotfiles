#!/usr/bin/env zsh

update_space() {
    SPACE_ID=$(echo "$INFO" | jq -r '."display-1"')

    case $SPACE_ID in
    1)
        ICON=󰊠
        ICON_PADDING_LEFT=10
        ICON_PADDING_RIGHT=9
        ;;
    2)
        ICON=" "
        ICON_PADDING_LEFT=10
        ICON_PADDING_RIGHT=9
        ;;
    3)
        ICON=" "
        ICON_PADDING_LEFT=10
        ICON_PADDING_RIGHT=8
        ;;
    4)
        ICON=" "
        ICON_PADDING_LEFT=10
        ICON_PADDING_RIGHT=8
        ;;
    5)
        ICON=" "
        ICON_PADDING_LEFT=10
        ICON_PADDING_RIGHT=8
        ;;
    *)
        ICON=$SPACE_ID
        ICON_PADDING_LEFT=9
        ICON_PADDING_RIGHT=10
        ;;
    esac

    sketchybar --set $NAME \
        icon=$ICON \
        icon.padding_left=$ICON_PADDING_LEFT \
        icon.padding_right=$ICON_PADDING_RIGHT
}

case "$SENDER" in
"mouse.clicked")
    # Reload sketchybar
    sketchybar --remove '/.*/'
    source $HOME/.config/sketchybar/sketchybarrc-main
    ;;
*)
    update_space
    ;;
esac
