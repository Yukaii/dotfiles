function get_gr --description 'Gets the root directory of the git repository'
  set git_root (git rev-parse --show-toplevel 2> /dev/null)

  if test -n "$git_root"
    echo $git_root
  else
    echo "Not inside a Git repository."
    return 1
  end
end

function cdgr --description 'Change directory to the root of git repository'
  set git_root (get_gr)

  if test -d "$git_root"
    cd $git_root
  else
    echo "Unable to change directory."
    return 1
  end
end
