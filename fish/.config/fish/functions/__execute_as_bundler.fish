function __execute_as_bundler
  if __is_a_bundled_executable $argv[1]
    command bundle exec $argv
  else
    eval command $argv
  end
end
