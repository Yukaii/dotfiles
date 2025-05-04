#!/bin/bash
# Required parameters:
# @raycast.title       YouTube Captions → SRT (via page JSON)
# @raycast.mode        fullOutput
# @raycast.schemaVersion 1
# Optional parameters:
# @raycast.icon        🎬
# @raycast.packageName YouTube Tools
# @raycast.refreshTime never
# @raycast.argument1    { "type": "text", "placeholder": "YouTube URL (optional)", "optional": true }
# Documentation:
# @raycast.description Extract captions by scraping the YouTube page JSON

# 1) Get URL: argument, stdin, or Safari
dbg() {
  if [[ "$1" == *DEBUG* || "$1" == *Error* ]]; then
    echo "$*" >&2
  elif [[ "$1" == *progress* && "$DEBUG" == "1" ]]; then
    echo "$*" >&2
  fi
}
DEBUG=0
for arg in "$@"; do
  [[ "$arg" == "--debug" ]] && DEBUG=1
done

if [[ -n "${1-}" && "$1" != "--debug" ]]; then
  URL="$1"; dbg "URL from arg: $URL"
elif ! tty -s && URL=$(cat); then
  dbg "URL from stdin: $URL"
else
  URL=$(/usr/bin/osascript <<'EOF'
tell application "Safari"
  if windows = {} then return ""
  return URL of current tab of front window
end tell
EOF
)
  dbg "URL from Safari: $URL"
fi

[[ -n "$URL" ]] || { echo "Error: no URL." >&2; exit 1; }

# Create temporary Python script
SCRIPT=$(mktemp)
trap 'rm -f "$SCRIPT"' EXIT

# Write Python script
cat > "$SCRIPT" <<'EOF'
#!/usr/bin/env python3
import sys
import os
import json
import html
import urllib.request
import xml.etree.ElementTree as ET
import re
from subprocess import check_output, PIPE
import io

def eprint(*args, **kwargs):
    """Print to stderr"""
    print(*args, file=sys.stderr, **kwargs)

def debug(msg):
    if "--debug" in sys.argv:
        eprint(f"[DEBUG] {msg}")

def progress(msg):
    if "--debug" in sys.argv:
        eprint(f"[progress] {msg}")


def fetch_captions(url):
    progress("Fetching video page...")

    # Get page HTML
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as resp:
        html = resp.read().decode('utf-8')
    debug(f"Fetched HTML, length={len(html)}")

    # Extract caption tracks
    match = re.search(r'"captionTracks":(\[.*?\]),"audioTracks"', html)
    if not match:
        eprint("Error: Could not extract captionTracks")
        sys.exit(1)

    tracks = json.loads(match.group(1))
    if not tracks:
        eprint("Error: No caption tracks found")
        sys.exit(1)

    # Get first track URL
    track = tracks[0]
    lang = track['languageCode']
    url = track['baseUrl']
    debug(f"Selected track: {lang} → {url}")

    # Download caption XML
    progress("Downloading caption XML...")
    req = urllib.request.Request(f"{url}&fmt=srv3")
    with urllib.request.urlopen(req) as resp:
        xml = resp.read().decode('utf-8')

    if not xml:
        eprint("Error: Failed to download XML content")
        sys.exit(1)

    debug(f"XML content length: {len(xml)}")
    debug("XML content preview:")
    debug(xml[:200] + "...")

    return xml

def xml_to_srt(xml):
    progress("Converting to SRT format...")

    try:
        root = ET.fromstring(xml)
    except ET.ParseError as e:
        eprint(f"Error parsing XML: {e}")
        eprint("XML content preview:")
        eprint(xml[:200] + "...")
        sys.exit(1)

    debug("XML parsed successfully")

    def fmt_time(ms):
        s = int(ms) // 1000
        ms = int(ms) % 1000
        m = s // 60
        s = s % 60
        h = m // 60
        m = m % 60
        return f"{h:02d}:{m:02d}:{s:02d},{ms:03d}"

    idx = 1
    for p in root.findall('.//p'):
        start = p.get('t')
        dur = p.get('d')
        if not all([start, dur]):
            continue

        end = int(start) + int(dur)
        text = ' '.join(s.text for s in p.findall('.//s') if s.text)
        if not text:
            continue

        print(idx)
        print(f"{fmt_time(start)} --> {fmt_time(end)}")
        print(html.unescape(text))
        print()
        sys.stdout.flush()
        idx += 1

    debug(f"Processed {idx-1} captions")

def main():
    try:
        if len(sys.argv) < 2 or not sys.argv[1]:
            eprint("Error: No URL provided")
            sys.exit(1)
        url = sys.argv[1]
        xml = fetch_captions(url)
        xml_to_srt(xml)
    except Exception as e:
        eprint(f"Error: {str(e)}")
        if "--debug" in sys.argv:
            import traceback
            eprint(traceback.format_exc())
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF

# Make script executable and run it
chmod +x "$SCRIPT"
PYTHONIOENCODING=utf-8 exec "$SCRIPT" "$URL" "${@:2}"
