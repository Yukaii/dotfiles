#!/bin/sh

CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.2f", s/100}')

sketchybar --push "$NAME" "$CPU_USAGE"