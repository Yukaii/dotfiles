#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PACKAGES_FILE="${SCRIPT_DIR}/packages.txt"

while IFS= read -r package || [[ -n "$package" ]]; do
  [[ -z "$package" || "$package" == \#* ]] && continue
  deno install -g --allow-all "$package"
done < "$PACKAGES_FILE"
