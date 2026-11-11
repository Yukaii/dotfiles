#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-build}"
case "$MODE" in
  build|--install|--install-app|--install-agent) ;;
  *) echo "Usage: $0 [--install | --install-agent | --install-app]" >&2; exit 2 ;;
esac

mkdir -p "$DIR/build"
swiftc -O -target "$(uname -m)-apple-macos13.0" \
  -framework AppKit -framework Foundation \
  -Xlinker -sectcreate -Xlinker __TEXT -Xlinker __info_plist -Xlinker "$DIR/Info.plist" \
  "$DIR/main.swift" -o "$DIR/build/voxtype-osd"
echo "Built $DIR/build/voxtype-osd"

install_bin() {
  mkdir -p "$HOME/.local/bin"
  install -m 755 "$DIR/build/voxtype-osd" "$HOME/.local/bin/voxtype-osd"
  echo "Installed to $HOME/.local/bin/voxtype-osd"
}

install_agent() {
  local plist="$HOME/Library/LaunchAgents/io.voxtype.osd.plist"
  mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs/voxtype"
  cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>io.voxtype.osd</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.local/bin/voxtype-osd</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>ProcessType</key>
    <string>Interactive</string>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/voxtype/osd.stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/voxtype/osd.stderr.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF
  launchctl bootout "gui/$(id -u)/io.voxtype.osd" 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$plist"
  echo "Loaded LaunchAgent io.voxtype.osd"
  echo "Disable Voxtype's bundled helper in ~/.config/voxtype/config.toml:"
  echo "  [osd]"
  echo "  enabled = false"
  echo "Then grant Accessibility to $HOME/.local/bin/voxtype-osd"
}

if [[ "$MODE" == "--install" ]]; then
  install_bin
elif [[ "$MODE" == "--install-agent" ]]; then
  install_bin
  install_agent
elif [[ "$MODE" == "--install-app" ]]; then
  echo "Warning: installing into Voxtype.app makes macOS attribute Accessibility to Voxtype, not this helper. Escape will not work. Prefer --install-agent." >&2
  APP_BIN="${VOXTYPE_APP:-/Applications/Voxtype.app}/Contents/MacOS"
  if [[ ! -x "$APP_BIN/voxtype-bin" ]]; then
    echo "Voxtype app not found at $APP_BIN (override with VOXTYPE_APP)." >&2
    exit 1
  fi
  install -m 755 "$DIR/build/voxtype-osd" "$APP_BIN/voxtype-osd"
  echo "Installed to $APP_BIN/voxtype-osd"
fi
