#!/usr/bin/env bash
set -euo pipefail

argc="${KAKOUNE_POPUP_ARGC:-0}"
if [[ ! "$argc" =~ ^[0-9]+$ ]]; then
  printf 'kakoune-popup: invalid argument count: %s\n' "$argc" >&2
  exit 2
fi

args=()
index=0
while [ "$index" -lt "$argc" ]; do
  name="KAKOUNE_POPUP_ARG_$index"
  if [[ ! ${!name+x} ]]; then
    printf 'kakoune-popup: missing argument %s\n' "$index" >&2
    exit 2
  fi
  args+=("${!name}")
  unset "$name"
  index=$((index + 1))
done
unset KAKOUNE_POPUP_ARGC

if [ "$argc" -eq 0 ]; then
  exec "${SHELL:-/bin/sh}" -l
fi

exec "${args[@]}"
