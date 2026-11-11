#!/usr/bin/env bash
set -eu

# LaunchAgents do not inherit the interactive shell's PATH.
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

command -v kb-remap >/dev/null || {
  echo 'kb-remap is missing; install it with cargo install kb-remap.' >&2
  exit 127
}

keyboards=(
  'Apple Internal Keyboard / Trackpad'
  'Keyboard K380'
)

# Allow up to a minute for the keyboards to become ready at login. Remap every
# keyboard that is currently connected, then stop; no background polling or
# reconnect handling. Keyboards that are absent are skipped, not failures.
for ((attempt = 1; attempt <= 13; attempt++)); do
  present=0
  unmapped=0
  for name in "${keyboards[@]}"; do
    kb-remap --list | grep -Fq -- "$name" || continue
    present=$((present + 1))
    kb-remap --name "$name" --swap capslock:lcontrol >/dev/null || unmapped=$((unmapped + 1))
  done
  if ((present > 0 && unmapped == 0)); then
    exit 0
  fi
  if ((attempt < 13)); then
    sleep 5
  fi
done
echo 'Keyboard remapping failed; run ~/.startup.sh to retry.' >&2
exit 1
