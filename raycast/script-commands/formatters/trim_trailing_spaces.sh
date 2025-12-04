#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Trim Trailing Spaces
# @raycast.packageName Developer Utils
# @raycast.mode pipe
# @raycast.inputType text
# @raycast.icon ✂️

sed 's/[[:space:]]*$//'
