function pm2_logs_chooser
    # Check if ecosystem.config.js exists
    if test -f ecosystem.config.js
        # Use Node.js to extract application names and pipe to fzf
        set APP_NAME (node -e "console.log(JSON.stringify(require('./ecosystem.config.js').apps.map(app => app.name)))" | jq -r '.[]' | fzf)

        # Run pm2 logs for the selected application
        pm2 logs $APP_NAME
    else
        echo "ecosystem.config.js not found."
    end
end
