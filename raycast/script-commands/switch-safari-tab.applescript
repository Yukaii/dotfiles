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
# @raycast.author Your Name
# @raycast.authorURL https://github.com/yourusername

(*
Safari Tab Switcher (Frontmost Window)

USAGE:
  This script switches to a specific tab in the frontmost Safari window.

  If a number is provided, it will try to switch to that tab index.
  If text is provided, it will try to find a tab with a title containing that text.
  If no argument is provided, it will display all available tabs.

EXAMPLES:
  3             # Switch to the 3rd tab in the frontmost window
  15            # Switch to the 15th tab in the frontmost window
  GitHub        # Switch to a tab containing "GitHub" in its title
*)

on run argv
  tell application "Safari"
    if (count of windows) is 0 then
      return "No Safari windows are open"
    end if

    set frontWindow to front window
    set tabCount to count of tabs of frontWindow

    -- If no arguments provided, list all tabs
    if (count of argv) is 0 then
      set tabList to "Available tabs in Safari:"
      repeat with i from 1 to tabCount
        set tabTitle to name of tab i of frontWindow
        set tabList to tabList & return & i & ": " & tabTitle
      end repeat
      return tabList
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
        set resultMessage to "Switched to tab " & tabIndex
      on error
        -- If tab index is invalid, treat input as text instead
        set isNumber to false
        set titleMatch to userInput
      end try
    end if

    -- If input is text or number failed, try to find matching tab title
    if not isNumber then
      set titleMatch to userInput
      set foundMatch to false

      repeat with i from 1 to tabCount
        set thisTab to tab i of frontWindow
        set tabTitle to name of thisTab

        -- Case-insensitive title matching
        if tabTitle contains titleMatch or (my toLowerCase(tabTitle) contains my toLowerCase(titleMatch)) then
          set current tab of frontWindow to thisTab
          set resultMessage to "Switched to tab with title containing \"" & titleMatch & "\""
          set foundMatch to true
          exit repeat
        end if
      end repeat

      -- No matching tab found
      if not foundMatch then
        return "No tab found with title containing \"" & titleMatch & "\""
      end if
    end if
  end tell

  -- Bring focus back to Safari after a delay
  do shell script "sleep 0.2 && osascript -e 'tell application \"Safari\" to activate' &"

  return resultMessage
end run

-- Helper function for case-insensitive comparison
on toLowerCase(inputString)
  set lowercaseString to do shell script "echo " & quoted form of inputString & " | tr '[:upper:]' '[:lower:]'"
  return lowercaseString
end toLowerCase
