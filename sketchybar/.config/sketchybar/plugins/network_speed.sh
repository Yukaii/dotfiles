#!/usr/bin/env bash

# Check if ifstat is available
if ! command -v ifstat &> /dev/null; then
    sketchybar --set network_down label="N/A" icon.highlight=off \
               --set network_up label="N/A" icon.highlight=off
    exit 0
fi

UPDOWN=$(ifstat -i "en0" -b 0.1 1 2>/dev/null | tail -n1)
DOWN=$(echo "$UPDOWN" | awk '{ print $1 }' | cut -f1 -d ".")
UP=$(echo "$UPDOWN" | awk '{ print $2 }' | cut -f1 -d ".")

# Fallback if no data
if [ -z "$DOWN" ] || [ -z "$UP" ]; then
    DOWN=0
    UP=0
fi

# Format download speed
DOWN_FORMAT=""
if [ "$DOWN" -gt "7999" ]; then
    DOWN_FORMAT=$(echo "$DOWN / 8000" | bc -l | awk '{ printf "%.1f MB/s", $1 }')
else
    DOWN_FORMAT=$(echo "$DOWN / 8" | bc -l | awk '{ printf "%.0f KB/s", $1 }')
fi

# Format upload speed
UP_FORMAT=""
if [ "$UP" -gt "7999" ]; then
    UP_FORMAT=$(echo "$UP / 8000" | bc -l | awk '{ printf "%.1f MB/s", $1 }')
else
    UP_FORMAT=$(echo "$UP / 8" | bc -l | awk '{ printf "%.0f KB/s", $1 }')
fi

sketchybar --set network_down label="$DOWN_FORMAT" icon.highlight=$(if [ "$DOWN" -gt "0" ]; then echo "on"; else echo "off"; fi) \
           --set network_up label="$UP_FORMAT" icon.highlight=$(if [ "$UP" -gt "0" ]; then echo "on"; else echo "off"; fi)