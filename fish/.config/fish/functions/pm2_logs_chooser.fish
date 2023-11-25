function pm2_logs_chooser
   argparse 'h/help' 'appName=' 'config=' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: pm2_logs_chooser [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --appName=APP_NAME    Specify the application name directly."
        echo "  --config=CONFIG_FILE  Specify the ecosystem configuration file (ecosystem.config.js or ecosystem.config.cjs)."
        echo "  -h, --help            Display this help message and exit."
        echo ""
        echo "Examples:"
        echo "  pm2_logs_chooser --appName=my_app"
        echo "  pm2_logs_chooser --config=ecosystem.config.js"
        echo "  pm2_logs_chooser --appName=my_app --config=ecosystem.config.js"
        return
    end

    # Default to known config file names if not set
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

    # If an app name is provided, use it directly
    if set -q _flag_appName
        set APP_NAME $_flag_appName
    else
        # Use Node.js to extract application names and pipe to fzf
        set APP_NAME (node -e "console.log(JSON.stringify(require('./$_flag_config').apps.map(app => app.name)))" | jq -r '.[]' | fzf)
    end

    # Check if an app was selected or provided
    if test -n "$APP_NAME"
        # Run pm2 logs for the selected or provided application
        pm2 logs $APP_NAME
    else
        echo "No application selected."
    end
end
