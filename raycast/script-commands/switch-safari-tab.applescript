#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Switch Safari Tab
# @raycast.mode silent
# @raycast.packageName Safari

# Optional parameters:
# @raycast.icon 🧭
# @raycast.argument1 { "type": "text", "placeholder": "Tab Index or Title", "optional": true }

# Documentation:
# @raycast.description Switch to a specific tab in the frontmost Safari window by index or title
# @raycast.author Yukai
# @raycast.authorURL https://github.com/Yukaii

(*
Safari Tab Switcher (Frontmost Window)

USAGE:
  This script switches to a specific tab in the frontmost Safari window.

  If a number is provided, it will try to switch to that tab index.
  If text is provided, it will try to find a tab with a title containing that text.
  If no argument is provided, it will do nothing.
*)

on run argv
  tell application "Safari"
    if (count of windows) is 0 then
      -- No windows open, silently exit
      return ""
    end if

    set frontWindow to front window
    set tabCount to count of tabs of frontWindow

    -- If no arguments provided, do nothing silently
    if (count of argv) is 0 then
      return ""
    end if

    set userInput to item 1 of argv

    -- Try to convert input to number
    set isNumber to true
    try
      set tabIndex to userInput as integer
    on error
      set isNumber to false
    end try

    -- If input is a number, try to switch by index
    if isNumber then
      try
        set current tab of frontWindow to tab tabIndex of frontWindow
      on error
        -- If tab index is invalid, treat input as text instead
        set isNumber to false
        set titleMatch to userInput
      end try
    end if

    -- If input is text or number failed, try to find matching tab title
    if not isNumber then
      set titleMatch to userInput

      repeat with i from 1 to tabCount
        set thisTab to tab i of frontWindow
        set tabTitle to name of thisTab

        -- Case-insensitive title matching
        if tabTitle contains titleMatch or (my toLowerCase(tabTitle) contains my toLowerCase(titleMatch)) then
          set current tab of frontWindow to thisTab
          exit repeat
        end if
      end repeat
    end if
  end tell

  -- Bring focus back to Safari after a delay
  do shell script "sleep 0.2 && osascript -e 'tell application \"Safari\" to activate' &"

  -- Return empty string for completely silent operation
  return ""
end run

-- Helper function for case-insensitive comparison
on toLowerCase(inputString)
  set lowercaseString to do shell script "echo " & quoted form of inputString & " | tr '[:upper:]' '[:lower:]'"
  return lowercaseString
end toLowerCase
