#!/bin/sh

selected_files=$(
    rg --line-number --column --no-heading --smart-case . \
    | fzf --multi --delimiter : --preview 'bat --style=full --color=always --highlight-line {2} {1}' --preview-window '~3,+{2}+3/2' --bind 'ctrl-q:select-all+accept'
)

line_count=$(echo "$selected_files" | grep -c '^')

if [ -n "$selected_files" ]; then
    if [ "$line_count" -eq "1" ]; then
        file=$(echo $selected_files | awk -F: '{print $1 ":" $2 ":" $3}')
        hx-wez $file top
    else
        qf_tmp=$(mktemp)
        echo "$selected_files" | awk -F: '{
            printf "%s:%s:%s    ", $1, $2, $3
            for (i = 4; i <= NF; i++) {
                printf "%s", $i
            }
            printf "\n"
        }' > "$qf_tmp"
        wezterm cli split-pane --bottom --percent 25 -- hx "$qf_tmp"
    fi
fi
