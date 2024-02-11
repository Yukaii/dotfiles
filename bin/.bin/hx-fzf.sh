#!/bin/sh

selected_file=$(rg --line-number --column --no-heading --smart-case . | fzf --delimiter : --preview 'bat --style=full --color=always --highlight-line {2} {1}' --preview-window '~3,+{2}+3/2' | awk '{ print $1 }' | cut -d: -f1,2,3)

echo $selected_file

if [ -n "$selected_file" ]; then
    hx-wez $selected_file top
fi

exit 0
