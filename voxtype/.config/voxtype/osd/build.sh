#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Compiling voxtype-osd..."
swiftc -O -target arm64-apple-macos13.0 -framework AppKit -framework Foundation "$DIR/main.swift" -o "$DIR/voxtype-osd"

if [ -d "/Applications/Voxtype.app/Contents/MacOS" ]; then
  cp "$DIR/voxtype-osd" "/Applications/Voxtype.app/Contents/MacOS/voxtype-osd"
  echo "Installed to /Applications/Voxtype.app/Contents/MacOS/voxtype-osd"
fi

mkdir -p "$HOME/.local/bin"
ln -sf "$DIR/voxtype-osd" "$HOME/.local/bin/voxtype-osd"
echo "Done!"
