#!/usr/bin/env bash
set -eu

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
agent="$HOME/Library/LaunchAgents/com.user.startup.plist"
domain="gui/$(id -u)"

if [[ ! -f "$HOME/.startup.sh" ]]; then
  echo 'Stow the startup package first: stow -n -v startup && stow startup' >&2
  exit 1
fi

mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
temporary_agent=$(mktemp)
trap 'rm -f "$temporary_agent"' EXIT
cp "$script_dir/com.user.startup.plist" "$temporary_agent"
/usr/bin/plutil -remove ProgramArguments.1 "$temporary_agent"
/usr/bin/plutil -insert ProgramArguments.1 -string "$HOME/.startup.sh" "$temporary_agent"
/usr/bin/plutil -replace StandardErrorPath -string "$HOME/Library/Logs/com.user.startup.err" "$temporary_agent"
/usr/bin/plutil -lint "$temporary_agent"

if launchctl print "$domain/com.user.startup" >/dev/null 2>&1; then
  launchctl bootout "$domain/com.user.startup"
fi
install -m 644 "$temporary_agent" "$agent"
launchctl enable "$domain/com.user.startup"
launchctl bootstrap "$domain" "$agent"
echo "Installed com.user.startup: runs at login and stops after success (up to 13 attempts)."
