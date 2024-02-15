# wakatime.kak version 3.1.2
# By Nodyn

decl str		wakatime_file
decl str		wakatime_options
decl bool		wakatime_debug		false

decl -hidden str	wakatime_version	"1.68.3"
decl -hidden str	wakatime_command        "wakatime-cli"
decl -hidden str	wakatime_plugin		%sh{ dirname "$kak_source" }

decl -hidden str	wakatime_beat_rate	120
decl -hidden str	wakatime_last_file
decl -hidden int	wakatime_last_beat


def -hidden	wakatime-heartbeat -params 0..1 %{
	evaluate-commands %sh{
		# First, if we're not in a real file, abort.
		if [ "$kak_buffile" = "$kak_bufname" ]; then
			exit
		fi

		# Still here? Let's get the current time.
		this=$(date "+%s")

		# Every command will look like that.
		command="$kak_opt_wakatime_command $kak_opt_wakatime_options --entity \"$kak_buffile\" --time $this"
		command="$command --plugin \"kakoune/$kak_version retrohacker/kak-waka\""

		# If we have the cursor position, then let's hand it off to WakaTime.
		if [ -n "$kak_cursor_byte_offset" ]; then
			command="$command --cursorpos $kak_cursor_byte_offset"
		fi

		# The command is complete, now let's see if we have to send a heartbeat?
		if [ "$kak_buffile" != "$kak_opt_wakatime_last_file" ]; then
			# The focused file changed, update the variable taking care of that and send an heartbeat.
			if [ "$kak_opt_wakatime_debug" = "true" ]; then
				echo "echo -debug '[WakaTime Debug] Heartbeat $this (Focus)'"
			fi
			echo "set global wakatime_last_file '$kak_buffile'"
			echo "set global wakatime_last_beat $this"
			(eval "$command") < /dev/null > /dev/null 2> /dev/null &
		elif [ "$1" = "write" ]; then
			# The focused file was flushed, send an heartbeat.
			if [ "$kak_opt_wakatime_debug" = "true" ]; then
				echo "echo -debug '[WakaTime Debug] Heartbeat $this (Write)'"
			fi
			echo "set global wakatime_last_beat $this"
			(eval "$command --write") < /dev/null > /dev/null 2> /dev/null &
		elif [ $(($this - ${kak_opt_wakatime_last_beat:-0})) -gt $kak_opt_wakatime_beat_rate ]; then
			# The last heartbeat was long ago enough, we need to let WakaTime know we're still up.
			if [ "$knopk_opt_wakatime_debug" = "true" ]; then
				echo "echo -debug '[WakaTime Debug] Heartbeat $this (Timeout)'"
			fi
			echo "set global wakatime_last_beat $this"
			(eval "$command") < /dev/null > /dev/null 2> /dev/null &
		fi
		echo "echo -debug $command"
	}
}


hook -group WakaTime global InsertKey .* %{ wakatime-heartbeat }
hook -group WakaTime global ModeChange push:.*:insert %{ wakatime-heartbeat }
hook -group WakaTime global BufWritePost .* %{ wakatime-heartbeat write }
hook -group WakaTime global BufCreate .* %{ wakatime-heartbeat }
