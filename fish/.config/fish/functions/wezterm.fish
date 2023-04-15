# https://shareg.pt/UFBSNrN
function wezl
  # Parse options
  set new_window 0
  set layout_string
  set cwd (pwd)

  for arg in $argv
    switch $arg
      case "--new-window"
        set new_window 1
      case "--cwd"
        set cwd (string trim (nextd))
        if test -z "$cwd"
          echo "Please provide a directory after --cwd."
          return 1
        end
      case "--help"
        echo "wezl - A simple layout manager for Wezterm."
        echo
        echo "Usage:"
        echo "  wezl [OPTIONS] LAYOUT_STRING"
        echo
        echo "Options:"
        echo "  --new-window        Create layout in a new window"
        echo "  --cwd <DIRECTORY>   Specify the current working directory"
        echo "  --help              Show this help message"
        echo
        echo "Layout string syntax:"
        echo "  |  - New tab"
        echo "  /  - Vertical split"
        echo "  =  - Horizontal split"
        echo
        echo "The layout string is executed in sequence, meaning each character is applied sequentially to create the desired layout."
        echo
        echo "Examples:"
        echo "  wezl '||=//='"
        echo "  wezl --new-window --cwd /path/to/directory '||=//='"
        echo
        echo "For the example given:"
        echo
        echo "Tab 1:"
        echo
        echo "+---------------------+"
        echo "|        Pane 1       |"
        echo "+---------------------+"
        echo 
        echo "Tab 2:"
        echo 
        echo "+---------------------+"
        echo "|        Pane 2       |"
        echo "+---------------------+"
        echo "|          |    |  5  |"
        echo "|  Pane 3  | 4  |-----|"
        echo "|          |    |  6  |"
        echo "+----------+----------+"

        return 0
      case "*"
        if test -z "$layout_string"
          set layout_string "$arg"
        else
          echo "Unknown argument: $arg"
          return 1
        end
    end
  end

  if test -z "$layout_string"
    echo "Please provide a layout string."
    return 1
  end

  set -g window_id
  set -g pane_id

  for symbol in (string split '' $layout_string)
    switch $symbol
      case "|"
        if test -n "$window_id"
          set pane_id (wezterm cli spawn --window-id $window_id --cwd $cwd)
        else
          if test $new_window -eq 1
            set pane_id (wezterm cli spawn --new-window --cwd $cwd)
            set window_id (wezterm cli list --format json | jq -r ".[] | select(.pane_id == $pane_id) | .window_id")
          else
            set pane_id $WEZTERM_PANE
            set window_id (wezterm cli list --format json | jq -r ".[] | select(.pane_id == $pane_id) | .window_id")
            # Create the first tab in the active window
            set pane_id (wezterm cli spawn --window-id $window_id --cwd $cwd)
          end
        end
      case "/"
        if test -z "$pane_id"
          set pane_id $WEZTERM_PANE
        end
        set pane_id (wezterm cli split-pane --pane-id $pane_id --right --percent 50 --cwd $cwd)
      case "="
        if test -z "$pane_id"
          set pane_id $WEZTERM_PANE
        end
        set pane_id (wezterm cli split-pane --pane-id $pane_id --bottom --percent 50 --cwd $cwd)
      case "*"
        echo "Unknown symbol in layout string: $symbol"
        return 1
    end
  end
end

complete -c wezl -l new-window -d "Create layout in a new window"
complete -c wezl -l cwd -d "Specify the current working directory" -r
complete -c wezl -l help -d "Show help message"

alias wezs "wezl '||/='"
alias wezc "wezl --new-window '||/='"
