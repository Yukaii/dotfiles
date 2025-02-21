# Disable file completions globally for spm
complete -c spm -f

# Helper function to check if spm has not received a subcommand
function __fish_spm_no_subcommand --description "Check if spm has not received a subcommand"
  for i in (commandline -opc)
    if contains -- $i start stop kill logs list jlist restart rotate
      return 1
    end
  end
  return 0
end

# Dynamic service names completion using spm jlist
function __fish_spm_process_names --description "Fetch list of spm services"
  spm jlist | jq -r '.[].name' 2>/dev/null
end

# Root-level subcommands with descriptions
complete -c spm -n '__fish_spm_no_subcommand' -a "start" -d "Start service instance(s)"
complete -c spm -n '__fish_spm_no_subcommand' -a "stop" -d "Stop service instance(s)"
complete -c spm -n '__fish_spm_no_subcommand' -a "kill" -d "Alias for 'stop'"
complete -c spm -n '__fish_spm_no_subcommand' -a "logs" -d "Display logs for service instance(s)"
complete -c spm -n '__fish_spm_no_subcommand' -a "list" -d "List services with running PIDs"
complete -c spm -n '__fish_spm_no_subcommand' -a "jlist" -d "List services in JSON format"
complete -c spm -n '__fish_spm_no_subcommand' -a "restart" -d "Restart service instance(s)"
complete -c spm -n '__fish_spm_no_subcommand' -a "rotate" -d "Manage log rotation"

# Dynamic service name completion for commands that take a service argument
for cmd in start stop restart logs kill
  complete -c spm -n "__fish_seen_subcommand_from $cmd" -a "(__fish_spm_process_names)" -d "Service names"
end

# Subcommand-specific completions for the logs command
complete -c spm -n '__fish_seen_subcommand_from logs' -a '--tail' -d "Tail log files in real time"
complete -c spm -n '__fish_seen_subcommand_from logs' -a '-h --help' -d "Show help"

# Completions for the rotate subcommand group
complete -c spm -n '__fish_seen_subcommand_from rotate' -a "start" -d "Perform log rotation and spawn rotate-watch process"
complete -c spm -n '__fish_seen_subcommand_from rotate' -a "watch" -d "Continuously watch and rotate logs"
complete -c spm -n '__fish_seen_subcommand_from rotate' -a "stop" -d "Stop the rotate-watch process"
