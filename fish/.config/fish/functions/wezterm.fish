# https://shareg.pt/xVGFrXf
function wezc
  # Set the default current working directory to the present working directory if no argument is given
  if test -n "$argv[1]"
    set cwd $argv[1]
  else
    set cwd (pwd)
  end

  # Create the first tab with the specified current working directory and obtain the pane ID
  set first_pane_id (wezterm cli spawn --new-window --cwd $cwd)

  # Obtain the window ID associated with the pane ID
  set window_id (wezterm cli list --format json | jq -r ".[] | select(.pane_id == $first_pane_id) | .window_id")

  # Create 4 additional tabs in the same window and store the pane IDs
  set -g pane_ids $first_pane_id
  for i in (seq 1 4)
    set pane_id (wezterm cli spawn --window-id $window_id --cwd $cwd)
    set pane_ids $pane_ids $pane_id
  end

  # Split the second tab with a 50%|50%/50% layout using the stored pane ID
  set second_tab_pane_id $pane_ids[2]
  set second_pane_id (wezterm cli split-pane --pane-id $second_tab_pane_id --right --percent 50 --cwd $cwd)
  wezterm cli split-pane --pane-id $second_pane_id --bottom --percent 50 --cwd $cwd
end
