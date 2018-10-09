function __is_a_bundled_executable
  if type -q bundle
    set -l bindir (command bundle exec ruby -e "puts Gem.bindir")
    test -f "$bindir/$argv"
  else
    return 1
  end
end
