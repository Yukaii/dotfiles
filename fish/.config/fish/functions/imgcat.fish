function _imgcat_usage
    echo "Usage: imgcat IMAGE ..."
    echo "   or: imgcat < IMAGE"
end

function _imgcat_print_image -a data name
    switch "$TERM"
        case screen\*
            printf "\033Ptmux;\033\033]"
        case \*
            printf "\033]"
    end

    printf "1337;File="

    if test ! -z "$name"
        printf "name="(echo -n "$name" | base64)";"

        wc -c < "$name"
    else
        set -l base64_options -D

        switch (base64 --version ^ /dev/stdout)[1]
            case \*GNU\*
                set base64_options -d
        end

        echo -n "$data" | base64 $base64_options | wc -c

    end | awk '{ printf("size=%d", $1) }'

    printf ";inline=1:$data"

    switch "$TERM"
        case screen\*
            printf "\a\033\\"

        case \*
            printf "\a"
    end

    printf "\n"
end

function imgcat -d "Display images in iTerm"
    if not set -q argv[1]
        if isatty
            _imgcat_usage > /dev/stderr
            return 1
        else
            base64 | read -l data
            _imgcat_print_image "$data"
            return
        end
    end

    for i in $argv
        switch "$i"
            case -h --help
                _imgcat_usage > /dev/stderr
                return

            case -\*
                echo "imgcat: Unknown option flag: $i" > /dev/stderr
                _imgcat_usage > /dev/stderr
                return 1

            case \*
                if test -r "$i"
                    _imgcat_print_image (base64 < "$i") "$i"
                else
                    echo "imgcat: $i: No such file or directory" > /dev/stderr
                    return 2
                end
        end
    end
end
