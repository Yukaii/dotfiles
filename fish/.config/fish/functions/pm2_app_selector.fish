function pm2_app_selector -a command
    argparse 'h/help' 'appName=' 'config=' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: pm2_app_selector [OPTIONS] -- [COMMAND]"
        echo ""
        echo "Options:"
        echo "  --appName=APP_NAME    Specify the application name directly."
        echo "  --config=CONFIG_FILE  Specify the ecosystem configuration file (ecosystem.config.js or ecosystem.config.cjs)."
        echo "  -h, --help            Display this help message and exit."
        echo ""
        echo "Examples:"
        echo "  pm2_app_selector --appName=my_app -- [COMMAND]"
        echo "  pm2_app_selector --config=ecosystem.config.js -- [COMMAND]"
        echo "  pm2_app_selector --appName=my_app --config=ecosystem.config.js -- [COMMAND]"
        return
    end

    if not set -q _flag_config
        if test -f ecosystem.config.js
            set _flag_config ecosystem.config.js
        else if test -f ecosystem.config.cjs
            set _flag_config ecosystem.config.cjs
        end
    end

    if not set -q _flag_config
        echo "No ecosystem configuration file found."
        return
    end

    if set -q _flag_appName
        set APP_NAME $_flag_appName
    else
        set APP_NAME (node -e "console.log(JSON.stringify(require('./$_flag_config').apps.map(app => app.name)))" | jq -r '.[]' | fzf)
    end

    if test -n "$APP_NAME"
        pm2 $command $APP_NAME
    else
        echo "No application selected."
    end
end

