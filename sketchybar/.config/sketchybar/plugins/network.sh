#!/bin/sh

UPDOWN=$(ifstat -i "en0" -b 0.1 1 2>/dev/null | tail -n1)
DOWN=$(echo $UPDOWN | awk "{ print \$1 }" | cut -d "." -f1)
UP=$(echo $UPDOWN | awk "{ print \$2 }" | cut -d "." -f1)

DOWN_FORMAT=""
UP_FORMAT=""

if [ "$DOWN" -gt 1024 ]; then
  DOWN_FORMAT=$(echo "$DOWN" | awk '{printf "%.0fM", $1/1024}')
else
  DOWN_FORMAT="${DOWN}K"
fi

if [ "$UP" -gt 1024 ]; then
  UP_FORMAT=$(echo "$UP" | awk '{printf "%.0fM", $1/1024}')
else
  UP_FORMAT="${UP}K"
fi

if [ -z "$DOWN" ] || [ -z "$UP" ]; then
  sketchybar --set "$NAME" label="N/A" icon.color=0xff6c7086 background.color=0xff6c7086
else
  sketchybar --set "$NAME" label="↓${DOWN_FORMAT} ↑${UP_FORMAT}" \
                            icon.color=0xfffab387 \
                            background.color=0xfffab387
fi