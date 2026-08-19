#!/usr/bin/env bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Desk Light
# @raycast.mode silent
# Optional parameters:
# @raycast.icon 💡
# @raycast.packageName Kasa
# @raycast.description Toggle the Kasa smart plug connected to the desk light.
# @raycast.author Yukai
# @raycast.authorURL https://github.com/Yukaii

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
helper="$script_dir/lib/kasa-toggle.bash"
[[ -r "$helper" ]] || helper="$script_dir/../lib/kasa-toggle.bash"

# shellcheck source=lib/kasa-toggle.bash
source "$helper"

toggle_kasa_plug "Desk light" KASA_DESK_LIGHT_IP
