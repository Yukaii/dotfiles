#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Format definition response
# @raycast.packageName Developer Utils
# @raycast.mode pipe
# @raycast.inputType text
# @raycast.icon 🔨

# Function to format a pair of lines
format_pair() {
    local name="$1"
    local arn="$2"

    # Remove '_revision' suffix if it exists
    name="${name%_revision}"

    if [[ "$arn" =~ arn:aws:ecs:[^:]+:[^:]+:task-definition/[^:]+:([0-9]+) ]]; then
        local revision="${BASH_REMATCH[1]}"
        echo "- [ ] ${name}: ${revision}"
    else
        echo "Unrecognized format: $arn"
    fi
}

# Read all input into a variable
input=$(cat)

# Process pairs of lines
echo "$input" | while IFS= read -r name && IFS= read -r arn; do
    if [ -n "$name" ] || [ -n "$arn" ]; then
        format_pair "$name" "$arn"
    fi
done
