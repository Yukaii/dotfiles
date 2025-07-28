declare-option -docstring "Path to ASCII sequence file" str ascii_sequence_file "%val{config}/sequences/example.txt"
declare-option -docstring "Playback speed in milliseconds between frames" int ascii_playback_speed 2000
declare-option -docstring "Whether to loop the sequence" bool ascii_loop true

declare-option -hidden str ascii_player_state "stopped"
declare-option -hidden int ascii_current_frame 0
declare-option -hidden str ascii_frames_dir
declare-option -hidden int ascii_frame_count
declare-option -hidden int ascii_last_update_time 0
declare-option -hidden str ascii_timer_fifo

define-command ascii-load-sequence -docstring "Load ASCII sequence from file" %{
    evaluate-commands %sh{
        file="$kak_opt_ascii_sequence_file"
        if [ ! -f "$file" ]; then
            echo "echo -markup '{Error}ASCII sequence file not found: $file'"
            exit 1
        fi

        # Create temporary directory for frames
        frames_dir="/tmp/kak_ascii_frames_$$"
        mkdir -p "$frames_dir"

        # Read and parse frames into separate files
        current_frame=""
        frame_count=0

        while IFS= read -r line || [ -n "$line" ]; do
            if [ "$line" = "---FRAME---" ]; then
                if [ -n "$current_frame" ]; then
                    frame_count=$((frame_count + 1))
                    # Remove trailing empty lines and normalize
                    normalized_frame=$(printf '%s' "$current_frame" | sed '/^[[:space:]]*$/d')
                    printf '%s' "$normalized_frame" > "$frames_dir/frame_$frame_count"
                    current_frame=""
                fi
            else
                if [ -n "$current_frame" ]; then
                    current_frame="$current_frame"$'\n'"$line"
                else
                    current_frame="$line"
                fi
            fi
        done < "$file"

        # Add last frame if exists
        if [ -n "$current_frame" ]; then
            frame_count=$((frame_count + 1))
            # Remove trailing empty lines and normalize
            normalized_frame=$(printf '%s' "$current_frame" | sed '/^[[:space:]]*$/d')
            printf '%s' "$normalized_frame" > "$frames_dir/frame_$frame_count"
        fi

        echo "set-option global ascii_frames_dir $frames_dir"
        echo "set-option global ascii_frame_count $frame_count"
        echo "set-option global ascii_current_frame 0"
        echo "echo -markup '{Information}Loaded $frame_count frames from $file'"
    }
}

define-command ascii-create-buffer -docstring "Create or switch to ASCII playback buffer" %{
    try %{
        buffer *ascii*
    } catch %{
        edit -scratch *ascii*
        set-option buffer readonly true
        set-option buffer filetype text
        map buffer normal q ':ascii-stop<ret>' -docstring 'stop ASCII playback'
        map buffer normal <space> ':ascii-toggle<ret>' -docstring 'toggle ASCII playback'
        map buffer normal r ':ascii-restart<ret>' -docstring 'restart ASCII sequence'
        echo -markup "{Information}ASCII buffer created. Press 'q' to stop, <space> to toggle, 'r' to restart"
    }
}

define-command ascii-update-frame -docstring "Update current frame in ASCII buffer" %{
    echo -debug "ascii-update-frame"
    evaluate-commands %sh{
        frame_count=$kak_opt_ascii_frame_count
        current=$kak_opt_ascii_current_frame
        frames_dir=$kak_opt_ascii_frames_dir

        echo "echo -debug \"Current frame: $current, Total frames: $frame_count\""

        if [ "$frame_count" -eq 0 ] || [ ! -d "$frames_dir" ]; then
            echo "echo -markup '{Error}No frames loaded. Use ascii-load-sequence first.'"
            exit 1
        fi

        # Get current frame (1-indexed)
        frame_index=$((current + 1))
        echo "echo -debug \"Displaying frame index: $frame_index\""

        if [ "$frame_index" -gt "$frame_count" ]; then
            if [ "$kak_opt_ascii_loop" = "true" ]; then
                frame_index=1
                echo "echo -debug \"Looping back to frame 1\""
                echo "set-option global ascii_current_frame 0"
            else
                echo "set-option global ascii_player_state stopped"
                echo "ascii-cleanup-timer-hooks"
                echo "echo -markup '{Information}ASCII sequence finished'"
                exit 0
            fi
        fi

        # Get frame file
        frame_file="$frames_dir/frame_$frame_index"

        if [ -f "$frame_file" ]; then
            echo "echo -debug \"Loading frame file: $frame_file\""
            echo "try %{
                echo -debug \'Trying to switch to *ascii* buffer\'
                buffer *ascii*
                echo -debug \'Successfully switched to *ascii* buffer\'
                set-option buffer readonly false
                execute-keys '%d'
                execute-keys '!cat $frame_file<ret>'
                execute-keys ','
                set-option buffer readonly true
                set-option global ascii_current_frame $((current + 1))
                echo -markup \'{Information}Frame $((current + 1))/$frame_count displayed'
                echo -debug \'Frame update completed successfully\'
            } catch %{
                echo -debug \'ERROR: Failed to update frame - %val{error}\'
                set-option global ascii_player_state stopped
                ascii-cleanup-timer-hooks
                echo -markup \\'{Error}ASCII buffer error: %val{error} - stopping playback\'
            }"
            echo "echo -debug \"Frame counter updated to: $((current + 1))\""
        else
            echo "echo -markup '{Error}Frame file not found: $frame_file'"
        fi
    }
}

define-command ascii-play -docstring "Start ASCII sequence playback" %{
    ascii-load-sequence
    ascii-create-buffer
    set-option global ascii_player_state "playing"
    evaluate-commands %sh{
        echo "set-option global ascii_last_update_time $(date +%s)"
    }
    ascii-setup-timer-hooks
    ascii-update-frame
}

define-command ascii-stop -docstring "Stop ASCII sequence playback" %{
    set-option global ascii_player_state "stopped"
    ascii-cleanup-timer-hooks
    evaluate-commands %sh{
        frames_dir=$kak_opt_ascii_frames_dir
        if [ -d "$frames_dir" ]; then
            echo "nop %sh{ rm -rf '$frames_dir' }"
        fi
    }
    set-option global ascii_current_frame 0
    try %{ delete-buffer *ascii* }
    echo -markup "{Information}ASCII playback stopped"
}

define-command ascii-pause -docstring "Pause ASCII sequence playback" %{
    evaluate-commands %sh{
        if [ "$kak_opt_ascii_player_state" = "playing" ]; then
            echo "set-option global ascii_player_state paused"
            echo "ascii-cleanup-timer-hooks"
            echo "echo -markup '{Information}ASCII playback paused'"
        elif [ "$kak_opt_ascii_player_state" = "paused" ]; then
            echo "set-option global ascii_player_state playing"
            echo "evaluate-commands %sh{ echo \"set-option global ascii_last_update_time \$(date +%s)\" }"
            echo "ascii-setup-timer-hooks"
            echo "echo -markup '{Information}ASCII playback resumed'"
        else
            echo "echo -markup '{Error}No active playback to pause/resume'"
        fi
    }
}

define-command ascii-toggle -docstring "Toggle ASCII sequence playback" %{
    evaluate-commands %sh{
        case "$kak_opt_ascii_player_state" in
            "playing") echo "ascii-pause" ;;
            "paused") echo "ascii-pause" ;;
            "stopped") echo "ascii-play" ;;
        esac
    }
}

define-command ascii-restart -docstring "Restart ASCII sequence from beginning" %{
    set-option global ascii_current_frame 0
    evaluate-commands %sh{
        if [ "$kak_opt_ascii_player_state" != "stopped" ]; then
            echo "ascii-update-frame"
            echo "echo -markup '{Information}ASCII sequence restarted'"
        else
            echo "ascii-play"
        fi
    }
}

define-command ascii-setup-timer-hooks -docstring "Setup native Kakoune timer for ASCII playback" %{
    echo -debug "ASCII Timer: Setting up timer hooks"
    ascii-cleanup-timer-hooks
    ascii-start-native-timer
}

define-command ascii-cleanup-timer-hooks -docstring "Stop native timer and cleanup" %{
    echo -debug "ASCII Timer: Cleaning up timer hooks"
    evaluate-commands %sh{
        if [ -n "$kak_opt_ascii_timer_fifo" ] && [ -p "$kak_opt_ascii_timer_fifo" ]; then
            echo "echo -debug 'ASCII Timer: Sending stop command to fifo: $kak_opt_ascii_timer_fifo'"
            echo "nop %sh{ echo stop > '$kak_opt_ascii_timer_fifo' 2>/dev/null || true }"
        else
            echo "echo -debug 'ASCII Timer: No active timer fifo to stop'"
        fi
    }
    set-option global ascii_timer_fifo ""
}

define-command ascii-start-native-timer -docstring "Start native timer using fifo pattern" %{
    echo -debug "ASCII Timer: Starting native timer"
    evaluate-commands %sh{
        if [ "$kak_opt_ascii_player_state" != "playing" ]; then
            echo "echo -debug 'ASCII Timer: Not starting - player state is: $kak_opt_ascii_player_state'"
            exit 0
        fi

        # Create timer fifo
        timer_fifo="/tmp/kak_ascii_timer_$$"
        mkfifo "$timer_fifo"

        echo "echo -debug 'ASCII Timer: Created fifo: $timer_fifo'"
        echo "set-option global ascii_timer_fifo '$timer_fifo'"
    }
    # Start the timer process using clean async pattern
    nop %sh{ {
        trap 'exit' INT TERM
        timer_fifo="$kak_opt_ascii_timer_fifo"
        delay_ms="$kak_opt_ascii_playback_speed"
        
        # Debug: Log timer startup
        echo "echo -debug 'ASCII Timer: Starting timer process with delay ${delay_ms}ms'" | kak -p "$kak_session"

        # Clamp delay to reasonable bounds
        if [ "$delay_ms" -lt 100 ]; then
            delay_ms=100
        elif [ "$delay_ms" -gt 10000 ]; then
            delay_ms=10000
        fi
        delay_s=$(awk "BEGIN {printf \"%.3f\", $delay_ms/1000}")
        
        echo "echo -debug 'ASCII Timer: Using delay ${delay_s}s, fifo: ${timer_fifo}'" | kak -p "$kak_session"

        # Test if fifo exists and is accessible
        if [ -p "$timer_fifo" ]; then
            echo "echo -debug 'ASCII Timer: Fifo exists and is a pipe'" | kak -p "$kak_session"
        else
            echo "echo -debug 'ASCII Timer: ERROR - Fifo does not exist or is not a pipe'" | kak -p "$kak_session"
            exit 1
        fi

        tick_count=0
        echo "echo -debug 'ASCII Timer: Entering main loop'" | kak -p "$kak_session"
        
        while true; do
            # Check for stop command using simple approach
            if [ -p "$timer_fifo" ] && [ -r "$timer_fifo" ]; then
                # Use dd to do a non-blocking read
                if cmd=$(dd if="$timer_fifo" bs=1 count=4 iflag=nonblock 2>/dev/null | head -c 4); then
                    if [ "$cmd" = "stop" ]; then
                        echo "echo -debug 'ASCII Timer: Received stop command after $tick_count ticks'" | kak -p "$kak_session"
                        break
                    fi
                fi
            fi

            sleep "$delay_s"
            tick_count=$((tick_count + 1))

            # Send timer tick to Kakoune with client context
            if echo "evaluate-commands -try-client '$kak_client' 'ascii-timer-tick'" | kak -p "$kak_session" 2>/dev/null; then
                # Log every 5th tick to reduce spam
                if [ $((tick_count % 5)) -eq 0 ]; then
                    echo "echo -debug 'ASCII Timer: Completed $tick_count ticks successfully'" | kak -p "$kak_session"
                fi
            else
                echo "echo -debug 'ASCII Timer: Failed to send tick #$tick_count, exiting'" | kak -p "$kak_session"
                break
            fi
        done

        echo "echo -debug 'ASCII Timer: Cleaning up and exiting'" | kak -p "$kak_session"
        rm -f "$timer_fifo"
    } > /dev/null 2>&1 < /dev/null & }
}

define-command ascii-timer-tick -docstring "Process one timer tick" %{
    evaluate-commands %sh{
        echo "echo -debug 'Timer tick received, state: $kak_opt_ascii_player_state'"
        
        if [ "$kak_opt_ascii_player_state" = "playing" ]; then
            current_time=$(date +%s)
            last_update=$kak_opt_ascii_last_update_time
            speed_s=$((kak_opt_ascii_playback_speed / 1000))

            if [ "$speed_s" -lt 1 ]; then
                speed_s=1
            fi

            elapsed=$((current_time - last_update))

            if [ "$elapsed" -ge "$speed_s" ]; then
                echo "echo -debug \"Timer tick: ${elapsed}s elapsed, updating frame\""
                echo "ascii-update-frame"
                echo "set-option global ascii_last_update_time $current_time"
            else
                echo "echo -debug \"Timer tick: Only ${elapsed}s elapsed, not updating (need ${speed_s}s)\""
            fi
        else
            echo "echo -debug 'Timer tick: Player not playing (state: $kak_opt_ascii_player_state), ignoring tick'"
        fi
    }
}

define-command ascii-check-timer -docstring "Legacy timer check - now redirects to tick system" %{
    ascii-timer-tick
}

declare-user-mode ascii-player
map global ascii-player p ':ascii-play<ret>' -docstring 'play sequence'
map global ascii-player s ':ascii-stop<ret>' -docstring 'stop playback'
map global ascii-player t ':ascii-toggle<ret>' -docstring 'toggle playback'
map global ascii-player r ':ascii-restart<ret>' -docstring 'restart sequence'
map global ascii-player l ':ascii-load-sequence<ret>' -docstring 'load sequence file'
map global ascii-player n ':ascii-next-frame<ret>' -docstring 'next frame manually'

map global user a ':enter-user-mode ascii-player<ret>' -docstring 'ASCII player mode'

define-command ascii-next-frame -docstring "Manually advance to next frame" %{
    evaluate-commands %sh{
        if [ "$kak_opt_ascii_frame_count" -eq 0 ]; then
            echo "echo -markup '{Error}No frames loaded. Use ascii-load-sequence first.'"
            exit 1
        fi

        current=$kak_opt_ascii_current_frame
        frame_count=$kak_opt_ascii_frame_count

        # Advance to next frame
        next_frame=$((current + 1))
        if [ "$next_frame" -gt "$frame_count" ]; then
            if [ "$kak_opt_ascii_loop" = "true" ]; then
                next_frame=1
                echo "set-option global ascii_current_frame 0"
            else
                echo "echo -markup '{Information}Reached end of sequence'"
                exit 0
            fi
        fi

        echo "set-option global ascii_current_frame $((next_frame - 1))"
        echo "ascii-update-frame"
    }
}
