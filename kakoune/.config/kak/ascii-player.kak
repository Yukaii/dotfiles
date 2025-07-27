declare-option -docstring "Path to ASCII sequence file" str ascii_sequence_file "%val{config}/sequences/example.txt"
declare-option -docstring "Playback speed in milliseconds between frames" int ascii_playback_speed 2000
declare-option -docstring "Whether to loop the sequence" bool ascii_loop true

declare-option -hidden str ascii_player_state "stopped"
declare-option -hidden int ascii_current_frame 0
declare-option -hidden str-list ascii_frames
declare-option -hidden int ascii_frame_count

define-command ascii-load-sequence -docstring "Load ASCII sequence from file" %{
    evaluate-commands %sh{
        file="$kak_opt_ascii_sequence_file"
        if [ ! -f "$file" ]; then
            echo "echo -markup '{Error}ASCII sequence file not found: $file'"
            exit 1
        fi
        
        # Read and parse frames into a list
        frames=""
        current_frame=""
        frame_count=0
        
        while IFS= read -r line || [ -n "$line" ]; do
            if [ "$line" = "---FRAME---" ]; then
                if [ -n "$current_frame" ]; then
                    frame_count=$((frame_count + 1))
                    # Remove trailing empty lines and normalize
                    normalized_frame=$(printf '%s' "$current_frame" | sed '/^[[:space:]]*$/d')
                    escaped_frame=$(printf '%s' "$normalized_frame" | sed "s/'/'\\''/g")
                    frames="$frames '$escaped_frame'"
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
            escaped_frame=$(printf '%s' "$normalized_frame" | sed "s/'/'\\''/g")
            frames="$frames '$escaped_frame'"
        fi
        
        # frame_count is already calculated during parsing
        
        echo "set-option global ascii_frames $frames"
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
    evaluate-commands %sh{
        frame_count=$kak_opt_ascii_frame_count
        current=$kak_opt_ascii_current_frame
        
        if [ "$frame_count" -eq 0 ]; then
            echo "echo -markup '{Error}No frames loaded. Use ascii-load-sequence first.'"
            exit 1
        fi
        
        # Get current frame (1-indexed)
        frame_index=$((current + 1))
        if [ "$frame_index" -gt "$frame_count" ]; then
            if [ "$kak_opt_ascii_loop" = "true" ]; then
                frame_index=1
                echo "set-option global ascii_current_frame 0"
            else
                echo "set-option global ascii_player_state stopped"
                echo "echo -markup '{Information}ASCII sequence finished'"
                exit 0
            fi
        fi
        
        # Extract the frame content
        frame_content=$(echo "$kak_opt_ascii_frames" | cut -d' ' -f"$frame_index" | sed "s/^'//; s/'$//; s/'\\\''/'/g")
        
        # Create a temporary file to hold the frame content
        temp_file="/tmp/kak_ascii_frame_$$"
        printf '%s' "$frame_content" > "$temp_file"
        
        echo "evaluate-commands -try-client %opt{jumpclient} %{
            try %{
                buffer *ascii*
                set-option buffer readonly false
                execute-keys '%d'
                execute-keys '!cat $temp_file<ret>'
                execute-keys ','
                set-option buffer readonly true
                set-option global ascii_current_frame $((current + 1))
            }
        }"
        
        echo "echo -markup '{Information}Frame $((current + 1))/$frame_count displayed'"
        
        echo "nop %sh{ rm -f '$temp_file' }"
    }
}

define-command ascii-play -docstring "Start ASCII sequence playback" %{
    ascii-load-sequence
    ascii-create-buffer
    set-option global ascii_player_state "playing"
    ascii-schedule-next-frame
}

define-command ascii-stop -docstring "Stop ASCII sequence playback" %{
    set-option global ascii_player_state "stopped"
    set-option global ascii_current_frame 0
    try %{ delete-buffer *ascii* }
    echo -markup "{Information}ASCII playback stopped"
}

define-command ascii-pause -docstring "Pause ASCII sequence playback" %{
    evaluate-commands %sh{
        if [ "$kak_opt_ascii_player_state" = "playing" ]; then
            echo "set-option global ascii_player_state paused"
            echo "echo -markup '{Information}ASCII playback paused'"
        elif [ "$kak_opt_ascii_player_state" = "paused" ]; then
            echo "set-option global ascii_player_state playing"
            echo "ascii-schedule-next-frame"
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

define-command ascii-schedule-next-frame -docstring "Schedule the next frame update" %{
    evaluate-commands %sh{
        if [ "$kak_opt_ascii_player_state" = "playing" ]; then
            speed_ms=$kak_opt_ascii_playback_speed
            speed_s=$(awk "BEGIN {printf \"%.3f\", $speed_ms/1000}")
            
            echo "ascii-update-frame"
            echo "nop %sh{
                (sleep $speed_s
                 if [ \"\$kak_opt_ascii_player_state\" = \"playing\" ]; then
                     printf 'evaluate-commands %%{ascii-schedule-next-frame}\n' | kak -p \$kak_session
                 fi) >/dev/null 2>&1 &
            }"
        fi
    }
}

declare-user-mode ascii-player
map global ascii-player p ':ascii-play<ret>' -docstring 'play sequence'
map global ascii-player s ':ascii-stop<ret>' -docstring 'stop playback'
map global ascii-player t ':ascii-toggle<ret>' -docstring 'toggle playback'
map global ascii-player r ':ascii-restart<ret>' -docstring 'restart sequence'
map global ascii-player l ':ascii-load-sequence<ret>' -docstring 'load sequence file'

map global user a ':enter-user-mode ascii-player<ret>' -docstring 'ASCII player mode'

define-command ascii-debug-frames -docstring "Debug frame parsing" %{
    evaluate-commands %sh{
        file="$kak_opt_ascii_sequence_file"
        echo "echo -markup '{Information}Debugging frames from: $file'"
        
        frame_count=0
        current_frame=""
        
        while IFS= read -r line || [ -n "$line" ]; do
            if [ "$line" = "---FRAME---" ]; then
                if [ -n "$current_frame" ]; then
                    frame_count=$((frame_count + 1))
                    line_count=$(echo "$current_frame" | wc -l)
                    echo "echo -markup '{Information}Frame $frame_count: $line_count lines'"
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
            line_count=$(echo "$current_frame" | wc -l)
            echo "echo -markup '{Information}Frame $frame_count: $line_count lines'"
        fi
        
        echo "echo -markup '{Information}Total frames: $frame_count'"
    }
}