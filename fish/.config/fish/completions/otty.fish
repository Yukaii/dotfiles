# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_otty_global_optspecs
	string join \n format= json no-headers q/quiet socket= config-file= timeout= y/yes h/help V/version
end

function __fish_otty_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_otty_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_otty_using_subcommand
	set -l cmd (__fish_otty_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c otty -n "__fish_otty_needs_command" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_needs_command" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_needs_command" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_needs_command" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_needs_command" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_needs_command" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_needs_command" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_needs_command" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_needs_command" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_needs_command" -s V -l version -d 'Print version'
complete -c otty -n "__fish_otty_needs_command" -f -a "open" -d 'Launch a new Otty window'
complete -c otty -n "__fish_otty_needs_command" -f -a "config" -d 'Manage configuration'
complete -c otty -n "__fish_otty_needs_command" -f -a "font" -d 'List available fonts'
complete -c otty -n "__fish_otty_needs_command" -f -a "theme" -d 'List available color themes'
complete -c otty -n "__fish_otty_needs_command" -f -a "keybind" -d 'List keybindings'
complete -c otty -n "__fish_otty_needs_command" -f -a "window" -d 'Manage windows (requires running app)'
complete -c otty -n "__fish_otty_needs_command" -f -a "tab" -d 'Manage tabs (requires running app)'
complete -c otty -n "__fish_otty_needs_command" -f -a "pane" -d 'Manage panes (requires running app)'
complete -c otty -n "__fish_otty_needs_command" -f -a "view" -d 'Open a file or URL inside an Otty pane, read-only by default (requires running app)'
complete -c otty -n "__fish_otty_needs_command" -f -a "edit" -d 'Open a file inside an Otty pane in edit mode (requires running app)'
complete -c otty -n "__fish_otty_needs_command" -f -a "watch" -d 'Run a command with progress badge (spinning → finish/error badge)'
complete -c otty -n "__fish_otty_needs_command" -f -a "features" -d 'Try terminal feature samples (colors, emoji, OSC sequences, images, …)'
complete -c otty -n "__fish_otty_needs_command" -f -a "state" -d 'Report an agent\'s lifecycle state (used by hooks and integrations). Invoked as `otty state:<kind> key=value ...` (e.g. `otty state:claude session-id=abc state=processing`)'
complete -c otty -n "__fish_otty_needs_command" -f -a "version" -d 'Show version information'
complete -c otty -n "__fish_otty_needs_command" -f -a "completions" -d 'Print a shell completion script to stdout'
complete -c otty -n "__fish_otty_needs_command" -f -a "jump" -d 'Jump to a frecency-ranked directory (requires running app). Sends `cd <path>\\n` to the focused pane'
complete -c otty -n "__fish_otty_needs_command" -f -a "learn" -d 'Record a directory visit in the frecency database. With no argument, records the focused pane\'s current cwd. (`learn` is multi-semantic — see `__learn` below for the unrelated autocomplete HelpProbe.)'
complete -c otty -n "__fish_otty_needs_command" -f -a "ignore" -d 'Undo `otty learn`. Forgets a per-folder command/script learned in the current dir if one matches exactly; otherwise black-lists a directory reference in the frecency DB (best-effort `zoxide remove <path>`) — by path shape, so a since-deleted folder still gets pruned. Tool specs learned from `--help` have no per-command undo'
complete -c otty -n "__fish_otty_needs_command" -f -a "import" -d 'Import data into Otty: another terminal\'s config (ghostty / kitty / alacritty), zoxide frecency, or a font file via `otty import <path-or-url>` (.ttf / .otf / .ttc / .otc)'
complete -c otty -n "__fish_otty_needs_command" -f -a "export" -d 'Export the current Otty config to another terminal\'s format (ghostty / kitty / alacritty). Default is stdout — use `-o <path>` to write to a file'
complete -c otty -n "__fish_otty_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand open" -l command -d 'Command to run in the new window' -r
complete -c otty -n "__fish_otty_using_subcommand open" -l title -d 'Window title' -r
complete -c otty -n "__fish_otty_using_subcommand open" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand open" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand open" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand open" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand open" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand open" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand open" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand open" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand open" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "show" -d 'Show the normalized config file contents'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "path" -d 'Print the config file path'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "get" -d 'Get one config key'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "set" -d 'Set one config key'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "unset" -d 'Remove one or more keys from the config file'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "edit" -d 'Open the config file in $EDITOR'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "validate" -d 'Validate the config file'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "reload" -d 'Reload config in the running app (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand config; and not __fish_seen_subcommand_from show path get set unset edit validate reload help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from path" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from get" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l reload -d 'Also reload config in running app'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l transient -d 'Apply to running app only, don\'t write to disk'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from set" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from unset" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from edit" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from validate" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from reload" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "show" -d 'Show the normalized config file contents'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "path" -d 'Print the config file path'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "get" -d 'Get one config key'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "set" -d 'Set one config key'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "unset" -d 'Remove one or more keys from the config file'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "edit" -d 'Open the config file in $EDITOR'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "validate" -d 'Validate the config file'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "reload" -d 'Reload config in the running app (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand config; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -f -a "list" -d 'List available fonts'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -f -a "apply" -d 'Apply a font family by writing `font-family = "<name>"` to the user config (`~/.config/otty/config.toml`). Equivalent to `otty config set font-family "<name>"`'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -f -a "import" -d 'Import a font file into `~/.config/otty/fonts/` so it shows up in the font picker and is usable as `font-family`. Accepts a local path or an http(s) URL (.ttf / .otf / .ttc / .otc)'
complete -c otty -n "__fish_otty_using_subcommand font; and not __fish_seen_subcommand_from list apply import help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l family -d 'Filter by font family name (substring match)' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l monospace -d 'Show only monospace fonts'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l system -d 'Only show fonts installed system-wide (excludes `~/.config/otty/fonts/`). Mutually exclusive with `--user`'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l user -d 'Only show user-supplied fonts from `~/.config/otty/fonts/`. Mutually exclusive with `--system`'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from apply" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -l apply -d 'Also set `font-family` to the imported font\'s family name. Restart Otty or run `otty config reload` for it to take effect'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from import" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from help" -f -a "list" -d 'List available fonts'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from help" -f -a "apply" -d 'Apply a font family by writing `font-family = "<name>"` to the user config (`~/.config/otty/config.toml`). Equivalent to `otty config set font-family "<name>"`'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from help" -f -a "import" -d 'Import a font file into `~/.config/otty/fonts/` so it shows up in the font picker and is usable as `font-family`. Accepts a local path or an http(s) URL (.ttf / .otf / .ttc / .otc)'
complete -c otty -n "__fish_otty_using_subcommand font; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -f -a "list" -d 'List available color themes'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -f -a "import" -d 'Import a color scheme file as a user theme (.itermcolors, or a kitty / alacritty / ghostty color file)'
complete -c otty -n "__fish_otty_using_subcommand theme; and not __fish_seen_subcommand_from list import help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -l color -d 'Filter by color scheme variant' -r -f -a "dark\t''
light\t''
all\t''"
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l activate -d 'Also switch to the imported theme (sets `theme = <slug>` in config)'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l overwrite -d 'If a theme with the same slug already exists, overwrite it in place instead of writing a `-1` / `-2` copy. Use when updating a theme you previously imported (e.g. re-pulling the latest from a URL)'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from import" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from help" -f -a "list" -d 'List available color themes'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from help" -f -a "import" -d 'Import a color scheme file as a user theme (.itermcolors, or a kitty / alacritty / ghostty color file)'
complete -c otty -n "__fish_otty_using_subcommand theme; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -f -a "list" -d 'List keybindings'
complete -c otty -n "__fish_otty_using_subcommand keybind; and not __fish_seen_subcommand_from list help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -l action -d 'Filter by action name (substring match)' -r
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from help" -f -a "list" -d 'List keybindings'
complete -c otty -n "__fish_otty_using_subcommand keybind; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -f -a "show" -d 'Show one window'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -f -a "list" -d 'List all windows'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -f -a "new" -d 'Create a new window'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -f -a "close" -d 'Close a window'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -f -a "focus" -d 'Focus a window'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -f -a "rename" -d 'Set a window title'
complete -c otty -n "__fish_otty_using_subcommand window; and not __fish_seen_subcommand_from show list new close focus rename help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -l window -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l cwd -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l command -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l title -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l no-focus
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from new" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l window -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l force
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from close" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -l window -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from focus" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -l window -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from rename" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from help" -f -a "show" -d 'Show one window'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all windows'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from help" -f -a "new" -d 'Create a new window'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from help" -f -a "close" -d 'Close a window'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from help" -f -a "focus" -d 'Focus a window'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from help" -f -a "rename" -d 'Set a window title'
complete -c otty -n "__fish_otty_using_subcommand window; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "show" -d 'Show one tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "list" -d 'List tabs'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "new" -d 'Create a new tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "close" -d 'Close a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "focus" -d 'Focus a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "rename" -d 'Rename a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "move" -d 'Move a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "badge" -d 'Set or clear the tab\'s status badge'
complete -c otty -n "__fish_otty_using_subcommand tab; and not __fish_seen_subcommand_from show list new close focus rename move badge help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -l tab -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -l window -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l window -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l cwd -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l command -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l title -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l after -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l no-focus
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from new" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l tab -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l force
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from close" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -l tab -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from focus" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -l tab -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from rename" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l tab -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l to-window -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l index -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from move" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l tab -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l kind -d 'Badge kind to set (omit when using --clear)' -r -f -a "running\t'Spinning activity indicator'
completed\t'Transient success checkmark'
finished\t'Accent-colored unread dot — signals a finished command'
unread\t'Accent-colored unread dot — alias of `finished` that reads as "this pane has unread output"; renders the same indicator'
error\t'Error alert triangle'
awaiting-input\t'Awaiting-input hand icon'"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l clear -d 'Remove the current badge'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from badge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "show" -d 'Show one tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "list" -d 'List tabs'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "new" -d 'Create a new tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "close" -d 'Close a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "focus" -d 'Focus a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "rename" -d 'Rename a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "move" -d 'Move a tab'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "badge" -d 'Set or clear the tab\'s status badge'
complete -c otty -n "__fish_otty_using_subcommand tab; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "show" -d 'Show one pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "list" -d 'List panes'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "split" -d 'Split a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "close" -d 'Close a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "focus" -d 'Focus a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "zoom" -d 'Toggle zoom on a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "resize" -d 'Resize a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "send-keys" -d 'Send keys to a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "capture" -d 'Capture pane text'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "badge" -d 'Set or clear the badge on the pane\'s tab'
complete -c otty -n "__fish_otty_using_subcommand pane; and not __fish_seen_subcommand_from show list split close focus zoom resize send-keys capture badge help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from show" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l window -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l tab -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l direction -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l cwd -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l command -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l title -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l size -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l no-focus
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from split" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l force
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from close" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l direction -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from focus" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from zoom" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l left -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l right -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l up -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l down -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from resize" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l bracketed-paste
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from send-keys" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l scope -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l lines -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l ansi
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l trim
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from capture" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l pane -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l kind -d 'Badge kind to set (omit when using --clear)' -r -f -a "running\t'Spinning activity indicator'
completed\t'Transient success checkmark'
finished\t'Accent-colored unread dot — signals a finished command'
unread\t'Accent-colored unread dot — alias of `finished` that reads as "this pane has unread output"; renders the same indicator'
error\t'Error alert triangle'
awaiting-input\t'Awaiting-input hand icon'"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l clear -d 'Remove the current badge'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from badge" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "show" -d 'Show one pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "list" -d 'List panes'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "split" -d 'Split a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "close" -d 'Close a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "focus" -d 'Focus a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "zoom" -d 'Toggle zoom on a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "resize" -d 'Resize a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "send-keys" -d 'Send keys to a pane'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "capture" -d 'Capture pane text'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "badge" -d 'Set or clear the badge on the pane\'s tab'
complete -c otty -n "__fish_otty_using_subcommand pane; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand view" -l mode -d 'Override the default mode for this invocation: `view` (read-only) or `edit` (editable). Defaults to read-only for `otty view` and editable for `otty edit`' -r -f -a "view\t'Read-only'
edit\t'Editable'"
complete -c otty -n "__fish_otty_using_subcommand view" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand view" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand view" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand view" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand view" -l new-tab -d 'Open in a new tab'
complete -c otty -n "__fish_otty_using_subcommand view" -l new-window -d 'Open in a new window'
complete -c otty -n "__fish_otty_using_subcommand view" -l left -d 'Split current pane to the left'
complete -c otty -n "__fish_otty_using_subcommand view" -l right -d 'Split current pane to the right'
complete -c otty -n "__fish_otty_using_subcommand view" -l top -d 'Split current pane to the top'
complete -c otty -n "__fish_otty_using_subcommand view" -l bottom -d 'Split current pane to the bottom'
complete -c otty -n "__fish_otty_using_subcommand view" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand view" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand view" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand view" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand view" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c otty -n "__fish_otty_using_subcommand edit" -l mode -d 'Override the default mode for this invocation: `view` (read-only) or `edit` (editable). Defaults to read-only for `otty view` and editable for `otty edit`' -r -f -a "view\t'Read-only'
edit\t'Editable'"
complete -c otty -n "__fish_otty_using_subcommand edit" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand edit" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand edit" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand edit" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand edit" -l new-tab -d 'Open in a new tab'
complete -c otty -n "__fish_otty_using_subcommand edit" -l new-window -d 'Open in a new window'
complete -c otty -n "__fish_otty_using_subcommand edit" -l left -d 'Split current pane to the left'
complete -c otty -n "__fish_otty_using_subcommand edit" -l right -d 'Split current pane to the right'
complete -c otty -n "__fish_otty_using_subcommand edit" -l top -d 'Split current pane to the top'
complete -c otty -n "__fish_otty_using_subcommand edit" -l bottom -d 'Split current pane to the bottom'
complete -c otty -n "__fish_otty_using_subcommand edit" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand edit" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand edit" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand edit" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand edit" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c otty -n "__fish_otty_using_subcommand watch" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand watch" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand watch" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand watch" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand watch" -s q -l quiet -d 'Suppress system notification on finish'
complete -c otty -n "__fish_otty_using_subcommand watch" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand watch" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand watch" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand watch" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -f -a "list" -d 'List all available feature demos'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -f -a "try" -d 'Run one feature\'s demo sample'
complete -c otty -n "__fish_otty_using_subcommand features; and not __fish_seen_subcommand_from list try help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from try" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from help" -f -a "list" -d 'List all available feature demos'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from help" -f -a "try" -d 'Run one feature\'s demo sample'
complete -c otty -n "__fish_otty_using_subcommand features; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand state" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand state" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand state" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand state" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand state" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand state" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand state" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand state" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand state" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand version" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand version" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand version" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand version" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand version" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand version" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand version" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand version" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand version" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand completions" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand completions" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand completions" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand completions" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand completions" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand completions" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand completions" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand completions" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand completions" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c otty -n "__fish_otty_using_subcommand jump" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand jump" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand jump" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand jump" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand jump" -l no-cd -d 'Resolve only — don\'t inject `cd \'<path>\'` into the focused pane. CLI still prints the path to stdout so a shell wrapper can `cd` locally (the zoxide-style flow used by Otty\'s shell integration)'
complete -c otty -n "__fish_otty_using_subcommand jump" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand jump" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand jump" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand jump" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand jump" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand learn" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand learn" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand learn" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand learn" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand learn" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand learn" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand learn" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand learn" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand learn" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand ignore" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand ignore" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand ignore" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand ignore" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand ignore" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand ignore" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand ignore" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand ignore" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand ignore" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -f -a "zoxide" -d 'Import frecency entries from a local `zoxide` install. Runs `zoxide query --list --score` and merges into Otty\'s `dir_frecency` table (existing rows keep max(score))'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -f -a "ghostty" -d 'Import a Ghostty config into Otty. Default location: `~/.config/ghostty/config` (macOS Application Support is checked as a fallback)'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -f -a "kitty" -d 'Import a Kitty config into Otty. Default location: `~/.config/kitty/kitty.conf`'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -f -a "alacritty" -d 'Import an Alacritty config into Otty. Default location: `~/.config/alacritty/alacritty.toml` (TOML — older YAML configs are not parsed)'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -f -a "theme" -d 'Import a color theme from a file or URL. Equivalent to `otty theme import` — `otty import theme <path-or-url>`, `otty import:theme …`, and `otty theme:import …` all run the same code'
complete -c otty -n "__fish_otty_using_subcommand import; and not __fish_seen_subcommand_from zoxide ghostty kitty alacritty theme help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from zoxide" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l overwrite -d 'Apply the import without prompting on conflicts — overwrite every conflicting key with the source\'s value. Without this flag, the CLI prints the preview and exits without writing anything'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l keep -d 'Keep current values on conflicts (apply only non-conflicting keys). Mutually exclusive with `--overwrite`. Without either flag the command is a dry run'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from ghostty" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l overwrite -d 'Apply the import without prompting on conflicts — overwrite every conflicting key with the source\'s value. Without this flag, the CLI prints the preview and exits without writing anything'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l keep -d 'Keep current values on conflicts (apply only non-conflicting keys). Mutually exclusive with `--overwrite`. Without either flag the command is a dry run'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from kitty" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l overwrite -d 'Apply the import without prompting on conflicts — overwrite every conflicting key with the source\'s value. Without this flag, the CLI prints the preview and exits without writing anything'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l keep -d 'Keep current values on conflicts (apply only non-conflicting keys). Mutually exclusive with `--overwrite`. Without either flag the command is a dry run'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from alacritty" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l activate -d 'Also switch to the imported theme (sets `theme = <slug>` in config)'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l overwrite -d 'If a theme with the same slug already exists, overwrite it in place instead of writing a `-1` / `-2` copy. Use when updating a theme you previously imported (e.g. re-pulling the latest from a URL)'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from theme" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from help" -f -a "zoxide" -d 'Import frecency entries from a local `zoxide` install. Runs `zoxide query --list --score` and merges into Otty\'s `dir_frecency` table (existing rows keep max(score))'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from help" -f -a "ghostty" -d 'Import a Ghostty config into Otty. Default location: `~/.config/ghostty/config` (macOS Application Support is checked as a fallback)'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from help" -f -a "kitty" -d 'Import a Kitty config into Otty. Default location: `~/.config/kitty/kitty.conf`'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from help" -f -a "alacritty" -d 'Import an Alacritty config into Otty. Default location: `~/.config/alacritty/alacritty.toml` (TOML — older YAML configs are not parsed)'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from help" -f -a "theme" -d 'Import a color theme from a file or URL. Equivalent to `otty theme import` — `otty import theme <path-or-url>`, `otty import:theme …`, and `otty theme:import …` all run the same code'
complete -c otty -n "__fish_otty_using_subcommand import; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -f -a "ghostty" -d 'Generate a Ghostty-format config from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -f -a "kitty" -d 'Generate a Kitty-format `kitty.conf` from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -f -a "alacritty" -d 'Generate an Alacritty-format `alacritty.toml` from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand export; and not __fish_seen_subcommand_from ghostty kitty alacritty help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -s o -l output -d 'Destination path. Omit to print the export to stdout' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from ghostty" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -s o -l output -d 'Destination path. Omit to print the export to stdout' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from kitty" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -s o -l output -d 'Destination path. Omit to print the export to stdout' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -l format -d 'Output format' -r -f -a "text\t''
json\t''"
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -l socket -d 'Override runtime control socket path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -l config-file -d 'Override config file path' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -l timeout -d 'IPC timeout in milliseconds' -r
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -l json -d 'Shortcut for --format json'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -l no-headers -d 'Suppress table headers in text list output'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -s q -l quiet -d 'Suppress non-essential success output'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -s y -l yes -d 'Skip destructive-action confirmation prompts'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from alacritty" -s h -l help -d 'Print help'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from help" -f -a "ghostty" -d 'Generate a Ghostty-format config from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from help" -f -a "kitty" -d 'Generate a Kitty-format `kitty.conf` from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from help" -f -a "alacritty" -d 'Generate an Alacritty-format `alacritty.toml` from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand export; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "open" -d 'Launch a new Otty window'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "config" -d 'Manage configuration'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "font" -d 'List available fonts'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "theme" -d 'List available color themes'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "keybind" -d 'List keybindings'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "window" -d 'Manage windows (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "tab" -d 'Manage tabs (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "pane" -d 'Manage panes (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "view" -d 'Open a file or URL inside an Otty pane, read-only by default (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "edit" -d 'Open a file inside an Otty pane in edit mode (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "watch" -d 'Run a command with progress badge (spinning → finish/error badge)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "features" -d 'Try terminal feature samples (colors, emoji, OSC sequences, images, …)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "state" -d 'Report an agent\'s lifecycle state (used by hooks and integrations). Invoked as `otty state:<kind> key=value ...` (e.g. `otty state:claude session-id=abc state=processing`)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "version" -d 'Show version information'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "completions" -d 'Print a shell completion script to stdout'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "jump" -d 'Jump to a frecency-ranked directory (requires running app). Sends `cd <path>\\n` to the focused pane'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "learn" -d 'Record a directory visit in the frecency database. With no argument, records the focused pane\'s current cwd. (`learn` is multi-semantic — see `__learn` below for the unrelated autocomplete HelpProbe.)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "ignore" -d 'Undo `otty learn`. Forgets a per-folder command/script learned in the current dir if one matches exactly; otherwise black-lists a directory reference in the frecency DB (best-effort `zoxide remove <path>`) — by path shape, so a since-deleted folder still gets pruned. Tool specs learned from `--help` have no per-command undo'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "import" -d 'Import data into Otty: another terminal\'s config (ghostty / kitty / alacritty), zoxide frecency, or a font file via `otty import <path-or-url>` (.ttf / .otf / .ttc / .otc)'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "export" -d 'Export the current Otty config to another terminal\'s format (ghostty / kitty / alacritty). Default is stdout — use `-o <path>` to write to a file'
complete -c otty -n "__fish_otty_using_subcommand help; and not __fish_seen_subcommand_from open config font theme keybind window tab pane view edit watch features state version completions jump learn ignore import export help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "show" -d 'Show the normalized config file contents'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "path" -d 'Print the config file path'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "get" -d 'Get one config key'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "set" -d 'Set one config key'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "unset" -d 'Remove one or more keys from the config file'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "edit" -d 'Open the config file in $EDITOR'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "validate" -d 'Validate the config file'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from config" -f -a "reload" -d 'Reload config in the running app (requires running app)'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from font" -f -a "list" -d 'List available fonts'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from font" -f -a "apply" -d 'Apply a font family by writing `font-family = "<name>"` to the user config (`~/.config/otty/config.toml`). Equivalent to `otty config set font-family "<name>"`'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from font" -f -a "import" -d 'Import a font file into `~/.config/otty/fonts/` so it shows up in the font picker and is usable as `font-family`. Accepts a local path or an http(s) URL (.ttf / .otf / .ttc / .otc)'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from theme" -f -a "list" -d 'List available color themes'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from theme" -f -a "import" -d 'Import a color scheme file as a user theme (.itermcolors, or a kitty / alacritty / ghostty color file)'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from keybind" -f -a "list" -d 'List keybindings'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from window" -f -a "show" -d 'Show one window'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from window" -f -a "list" -d 'List all windows'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from window" -f -a "new" -d 'Create a new window'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from window" -f -a "close" -d 'Close a window'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from window" -f -a "focus" -d 'Focus a window'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from window" -f -a "rename" -d 'Set a window title'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "show" -d 'Show one tab'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "list" -d 'List tabs'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "new" -d 'Create a new tab'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "close" -d 'Close a tab'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "focus" -d 'Focus a tab'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "rename" -d 'Rename a tab'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "move" -d 'Move a tab'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from tab" -f -a "badge" -d 'Set or clear the tab\'s status badge'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "show" -d 'Show one pane'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "list" -d 'List panes'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "split" -d 'Split a pane'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "close" -d 'Close a pane'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "focus" -d 'Focus a pane'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "zoom" -d 'Toggle zoom on a pane'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "resize" -d 'Resize a pane'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "send-keys" -d 'Send keys to a pane'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "capture" -d 'Capture pane text'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from pane" -f -a "badge" -d 'Set or clear the badge on the pane\'s tab'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from features" -f -a "list" -d 'List all available feature demos'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from features" -f -a "try" -d 'Run one feature\'s demo sample'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from import" -f -a "zoxide" -d 'Import frecency entries from a local `zoxide` install. Runs `zoxide query --list --score` and merges into Otty\'s `dir_frecency` table (existing rows keep max(score))'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from import" -f -a "ghostty" -d 'Import a Ghostty config into Otty. Default location: `~/.config/ghostty/config` (macOS Application Support is checked as a fallback)'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from import" -f -a "kitty" -d 'Import a Kitty config into Otty. Default location: `~/.config/kitty/kitty.conf`'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from import" -f -a "alacritty" -d 'Import an Alacritty config into Otty. Default location: `~/.config/alacritty/alacritty.toml` (TOML — older YAML configs are not parsed)'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from import" -f -a "theme" -d 'Import a color theme from a file or URL. Equivalent to `otty theme import` — `otty import theme <path-or-url>`, `otty import:theme …`, and `otty theme:import …` all run the same code'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from export" -f -a "ghostty" -d 'Generate a Ghostty-format config from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from export" -f -a "kitty" -d 'Generate a Kitty-format `kitty.conf` from the current Otty config'
complete -c otty -n "__fish_otty_using_subcommand help; and __fish_seen_subcommand_from export" -f -a "alacritty" -d 'Generate an Alacritty-format `alacritty.toml` from the current Otty config'
