#!/bin/sh

set -x

export EDITOR="hx-wez"

status_line=$(wezterm cli get-text | rg -e "(?:NORMAL|INSERT|SELECT)\s+[\x{2800}-\x{28FF}]*\s+(\S*)\s[^│]* (\d+):*.*" -o --replace '$1 $2')
filename=$(echo $status_line | awk '{ print $1}')
line_number=$(echo $status_line | awk '{ print $2}')

session_name=$(echo $PWD | sed "s:$HOME:~:" | tr '/' '_')

get_pane_direction() {
  general_direction=$1

  case $general_direction in
    bottom)
      echo "down"
      ;;
    left)
      echo "left"
      ;;
    right)
      echo "right"
      ;;
    top)
      echo "up"
      ;;
    *)
      echo "Error: Invalid direction. Only 'bottom' and 'left' are supported." >&2
      return 1
      ;;
  esac
}

spawn_pane() {
  direction=$1 # The direction to spawn or activate the pane (e.g., bottom, left)
  command=$2   # The command to spawn the pane
  percent=$3   # The percentage of the pane to be spawned
  zoom=$4      # Whether to zoom the pane or not


  pane_direction=$(get_pane_direction $direction)

  # Exit if get_pane_direction returned an error
  if [ $? -ne 0 ]; then
    return 1
  fi

  pane_id=$(wezterm cli get-pane-direction $pane_direction)

  if [ -z "${pane_id}" ]; then
    # Spawn a new pane directly since there is no pane in the specified direction
    pid=$(wezterm cli split-pane --${direction} --percent $percent -- $command)
    if [ "$zoom" = "true" ]; then
      wezterm cli zoom-pane --pane-id $pid
    fi
  else
    # Activate the pane in the specified direction if it exists
    wezterm cli activate-pane-direction --pane-id $pane_id $pane_direction
  fi
}

basedir=$(dirname "$filename")
basename=$(basename "$filename")
basename_without_extension="${basename%.*}"
extension="${filename##*.}"

case "$1" in
  "blame")
    winmux sp "tig blame $filename +$line_number"
    ;;
  "explorer")
    left_pane_id=$(wezterm cli get-pane-direction left)
    if [ -z "${left_pane_id}" ]; then
      # left_pane_id=$(wezterm cli split-pane --left --percent 23)
      spawn_pane "left" "broot --listen $session_name" 23
    else
      broot --send $session_name -c ":focus $PWD/$basedir"
      wezterm cli activate-pane-direction left
    fi
    ;;
  "fzf")
    winmux popup "sh hx-fzf.sh"
    # spawn_pane "bottom" "sh hx-fzf.sh" 33 "true"
    ;;
  "open")
    gh browse $filename:$line_number  
    ;;
esac
