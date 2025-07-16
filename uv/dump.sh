#! /usr/bin/env bash
uv tool list | grep -E "^[a-zA-Z0-9_-]+ v[0-9]" | awk '{print $1}' > packages.txt