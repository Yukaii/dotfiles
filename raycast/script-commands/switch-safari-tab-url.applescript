#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Switch Safari Tab by URL
# @raycast.mode silent
# @raycast.packageName Safari

# Optional parameters:
# @raycast.icon 🧭
# @raycast.argument1 { "type": "text", "placeholder": "Tab URL", "optional": true }

# Documentation:
# @raycast.description Switch to a specific tab in the frontmost Safari window by matching the tab's URL
# @raycast.author Yukai
# @raycast.authorURL https://github.com/Yukaii

(*
Safari Tab Switcher (URL-based)

USAGE:
  This script switches to a specific tab in the frontmost Safari window by matching the tab's URL.
  It searches the tab list for a tab whose URL contains the provided text (case-insensitive).
  If no argument is provided, the script does nothing.
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
    set inputLower to my toLowerCase(userInput)
    set foundTab to missing value

    repeat with i from 1 to tabCount
      set thisTab to tab i of frontWindow
      set tabUrl to URL of thisTab
      if tabUrl is not missing value then
        if my toLowerCase(tabUrl) contains inputLower then
          set foundTab to thisTab
          exit repeat
        end if
      end if
    end repeat

    if foundTab is not missing value then
      set current tab of frontWindow to foundTab
    end if
  end tell

  -- Bring focus back to Safari after a delay
  do shell script "sleep 0.2 && osascript -e 'tell application \"Safari\" to activate' &"
  return ""
end run

on toLowerCase(inputString)
  set lowercaseString to do shell script "echo " & quoted form of inputString & " | tr '[:upper:]' '[:lower:]'"
  return lowercaseString
end toLowerCase

