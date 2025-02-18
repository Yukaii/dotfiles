function activate_venv --on-variable PWD
    # If a virtual environment is active, check if we're still inside its project directory.
    if set -q VIRTUAL_ENV
        # Assume the project directory is the parent of the venv folder.
        set project_dir (dirname "$VIRTUAL_ENV")
        # Build a regex that matches the project directory and its subdirectories.
        set regex (string join "" "^" "$project_dir" '(/.*)?$')
        # If the current directory ($PWD) is NOT within project_dir (or its subdirectories)...
        if not string match -qr "$regex" "$PWD"
            # ...and if a deactivate function exists, then deactivate.
            if functions -q deactivate
                deactivate
            end
        end
    end

    # Check if the current directory contains a .venv activation script.
    if test -f "$PWD/.venv/bin/activate.fish"
        # Activate only if there's no virtual environment active,
        # or if the active venv isn't the one in the current directory.
        if not set -q VIRTUAL_ENV
            source "$PWD/.venv/bin/activate.fish"
        else if test "$VIRTUAL_ENV" != "$PWD/.venv"
            source "$PWD/.venv/bin/activate.fish"
        end
    end
end

# Run once on shell startup to handle the starting directory.
activate_venv
