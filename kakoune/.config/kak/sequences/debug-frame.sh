#!/bin/bash

# Extract specific frame from ASCII sequence file
# Usage: debug-frame.sh <file> <frame_number>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <file> <frame_number>"
    exit 1
fi

file="$1"
target_frame="$2"

if [ ! -f "$file" ]; then
    echo "Error: File not found: $file"
    exit 1
fi

# Store frames in array
declare -a frame_array
current_frame=""
frame_count=0

while IFS= read -r line || [ -n "$line" ]; do
    if [ "$line" = "---FRAME---" ]; then
        if [ -n "$current_frame" ]; then
            frame_count=$((frame_count + 1))
            # Remove trailing empty lines
            normalized_frame=$(printf '%s' "$current_frame" | sed '/^[[:space:]]*$/d')
            frame_array[frame_count]="$normalized_frame"
            current_frame=""
        fi
    else
        if [ -n "$current_frame" ]; then
            current_frame="$current_frame"$'\n'"$line"
        else
            current_frame="$line"
        fi
    fi
done < "$file"

# Add last frame if exists
if [ -n "$current_frame" ]; then
    frame_count=$((frame_count + 1))
    normalized_frame=$(printf '%s' "$current_frame" | sed '/^[[:space:]]*$/d')
    frame_array[frame_count]="$normalized_frame"
fi

echo "Total frames: $frame_count"

if [ "$target_frame" -lt 1 ] || [ "$target_frame" -gt "$frame_count" ]; then
    echo "Error: Frame $target_frame out of range (1-$frame_count)"
    exit 1
fi

# Extract target frame
frame_content="${frame_array[$target_frame]}"

echo "Frame $target_frame content:"
printf '%s' "$frame_content"