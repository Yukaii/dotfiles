function tunnel --description "ngrok alternative"
  set --local options 'p/port=!_validate_int' 'h/help'

  argparse $options -- $argv

  if set --query _flag_help; or not set -q _flag_port
    printf "Usage: tunnel [OPTIONS]\n\n"
    printf "Options:\n"
    printf "  -p --port       Local port to bind\n"
    return 0
  end

  eval "inlets client --remote=wss://$INLETS_REMOTE --upstream=http://localhost:$_flag_port -t $INLETS_AUTH_TOKEN"
end
