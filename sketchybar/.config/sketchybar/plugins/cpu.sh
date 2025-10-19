#!/bin/sh

CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')

case ${CPU_USAGE} in
  [8-9][0-9]|100) COLOR=0xfff38ba8;;
  [6-7][0-9]) COLOR=0xfffab387;;
  [4-5][0-9]) COLOR=0xfff9e2af;;
  [2-3][0-9]) COLOR=0xffa6e3a1;;
  *) COLOR=0xff89b4fa;;
esac

sketchybar --set "$NAME" label="${CPU_USAGE}%" \
                          icon.color="$COLOR" \
                          background.color="$COLOR"