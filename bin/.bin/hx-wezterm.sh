#!/bin/sh

set -x

status_line=$(wezterm cli get-text | rg -e "(?:NORMAL|INSERT|SELECT)\s+[\x{2800}-\x{28FF}]*\s+(\S*)\s[^│]* (\d+):*.*" -o --replace '$1 $2')
filename=$(echo $status_line | awk '{ print $1}')
line_number=$(echo $status_line | awk '{ print $2}')

session_name=$(echo $PWD | sed "s:$HOME:~:" | tr '/' '_')

split_pane_down() {
  bottom_pane_id=$(wezterm cli get-pane-direction down)
  if [ -z "${bottom_pane_id}" ]; then
    bottom_pane_id=$(wezterm cli split-pane)
  fi

  wezterm cli activate-pane-direction --pane-id $bottom_pane_id down

  send_to_bottom_pane="wezterm cli send-text --pane-id $bottom_pane_id --no-paste"
  program=$(wezterm cli list | awk -v pane_id="$bottom_pane_id" '$3==pane_id { print $6 }')
  if [ "$program" = "lazygit" ]; then
    echo "q" | $send_to_bottom_pane
  fi
}

get_pane_direction() {
  general_direction=$1

  case $general_direction in
    bottom)
      echo "down"
      ;;
    left)
      echo "left"
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
    spawn_pane "bottom" "tig blame $filename +$line_number" 50
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
    split_pane_down
    echo "hx-fzf.sh \$(rg --line-number --column --no-heading --smart-case . | fzf --delimiter : --preview 'bat --style=full --color=always --highlight-line {2} {1}' --preview-window '~3,+{2}+3/2' | awk '{ print \$1 }' | cut -d: -f1,2,3)" | $send_to_bottom_pane
    ;;
  "lazygit")
    spawn_pane "bottom" "lazygit" 1 "true"
    ;;
  "terminal")
    spawn_pane "bottom" "fish" 1 "true"
    ;;
  "open")
    gh browse $filename:$line_number  
    ;;
esac
