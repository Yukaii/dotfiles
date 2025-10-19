#!/bin/sh

MEMORY_USAGE=$(vm_stat | awk '
  /page size of/ { page_size = $8 }
  /Pages free/ { free = $3 * page_size }
  /Pages active/ { active = $3 * page_size }
  /Pages inactive/ { inactive = $3 * page_size }
  /Pages speculative/ { speculative = $3 * page_size }
  /Pages wired down/ { wired = $4 * page_size }
  /Pages occupied by compressor/ { compressed = $5 * page_size }
  END {
    total_used = active + inactive + wired + compressed
    total_free = free + speculative
    total = total_used + total_free
    printf "%.0f", (total_used / total) * 100
  }
')

case ${MEMORY_USAGE} in
  [8-9][0-9]|100) COLOR=0xfff38ba8;;
  [7-8][0-9]) COLOR=0xfffab387;;
  [5-6][0-9]) COLOR=0xfff9e2af;;
  [3-4][0-9]) COLOR=0xffa6e3a1;;
  *) COLOR=0xff89b4fa;;
esac

sketchybar --set "$NAME" label="${MEMORY_USAGE}%" \
                          icon.color="$COLOR" \
                          background.color="$COLOR"