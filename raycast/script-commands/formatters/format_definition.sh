#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Format definition response
# @raycast.packageName Developer Utils
# @raycast.mode pipe
# @raycast.inputType text
# @raycast.icon 🔨

# Function to format each line
format_line() {
    local line="$1"

    # Check if the line contains 'arn:aws'
    if [[ "$line" =~ arn:aws:ecs:[^:]+:[^:]+:task-definition/([-A-Za-z0-9]+):([0-9]+) ]]; then
        local name="${BASH_REMATCH[1]}"
        local revision="${BASH_REMATCH[2]}"
        echo "- [ ] ${name}: ${revision}"
    # else
    #     echo "Unrecognized format: $line"
    fi
}

# Read lines from input
while IFS= read -r line; do
    format_line "$line"
done
