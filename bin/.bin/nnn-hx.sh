#!/usr/bin/env sh

fpath="$1"

pane_id=$(wezterm cli get-pane-direction right)
if [ -z "${pane_id}" ]; then
  pane_id=$(wezterm cli split-pane --right --percent 80)
fi

program=$(wezterm cli list | awk -v pane_id="$pane_id" '$3==pane_id { print $6 }')
if [ "$program" = "hx" ]; then
  echo ":open ${fpath}\r" | wezterm cli send-text --pane-id $pane_id --no-paste
else
  wezterm cli spawn --pane-id $pane_id --cwd "${pwd}" -- hx "${fpath}"
fi

wezterm cli activate-pane-direction --pane-id $pane_id right
