# Some useful shell script I made

## [`switch-app-icon`](./.bin/switch-app-icon)

Set a Finder custom icon on a macOS application from any supported image format.
Reset it with `--reset` before redistributing or strictly verifying a signed app.

```bash
switch-app-icon "Ghostty" ~/Pictures/ghostty.png
switch-app-icon --reset "Ghostty"
```

## [`switch-image-type`](./.bin/switch-image-type)

Convert an image based on the output filename's extension. It uses macOS `sips`
and supports formats such as PNG, JPEG, HEIC, TIFF, WebP input, and ICNS output.

```bash
switch-image-type photo.webp photo.png
switch-image-type logo.png AppIcon.icns
```

## [`appify-sh`](./.bin/appify-sh)

Turn TUI commands into native, lightweight macOS `.app` bundles powered by Kitty, WezTerm, or Ghostty. Replaces heavy embedded wrappers with native terminal backends to preserve battery life while retaining custom Dock icons, application switcher entries, and dedicated windows.

### Usage

```bash
appify-sh [options] [--] <command> [args...]
```

### Options

- `-n, --name <name>`: Application display name (default: derived from command)
- `-i, --icon <path>`: Path to icon (`.png` or `.icns`)
- `-t, --terminal <engine>`: Terminal backend: `kitty` (default), `wezterm`, or `ghostty`
- `-o, --output <dir>`: Output directory (default: `~/Applications`)
- `-b, --bundle-id <id>`: Bundle Identifier (default: `com.local.<name>`)
- `-e, --env <KEY=VAL>`: Set environment variable (can be used multiple times)
- `--cwd <path>`: Initial working directory
- `--shell`: Run command inside an interactive login shell (`${SHELL:-/bin/zsh} -ilc`), so `.zprofile`/`.zshrc` run and TUI tools get mise activation, aliases, colors, and shell integration
- `--helper`: Ghostty only, bundle a private, ad-hoc signed Ghostty helper app for a self-contained Dock/Cmd-Tab identity
- `-h, --help`: Show help message

### Backends & Findings

- **`kitty` (default)**: Works best if you want full Kitty image protocol support (inline images, avatars, album art). Automatically configured with `-o confirm_os_window_close=0` for prompt-free launch and clean exit.
- **`wezterm`**: Works well, reliable, and prompt-free.
- **`ghostty`**: Opens a dedicated Ghostty window with the command as its initial surface, preserving command arguments without triggering wrapper lifecycle or saved-window restoration alerts. With `--helper`, a private copy of Ghostty is embedded under the app's `Resources/` and re-signed ad-hoc, giving the generated app its own standalone Dock and Cmd-Tab identity. The bundle icon is applied at runtime from the bundled `AppIcon.icns`, so the app stays self-contained and can be moved anywhere.

### Examples

```bash
# Create Concord app with Kitty graphics protocol support (default)
appify-sh -n "Concord" -i /Applications/Discord.app/Contents/Resources/electron.icns -- concord

# Create SpotaTUI app using Kitty backend
appify-sh -n "SpotaTUI" -i /Applications/Spotify.app/Contents/Resources/AppIcon.icns -- spotatui

# Create Btop app using WezTerm backend
appify-sh -n "Btop" -t wezterm -- btop

# Create a standalone Fresh editor app with its own bundled Ghostty helper
appify-sh --helper -n "Fresh" -t ghostty \
  -i /path/to/fresh.png -- fresh
```

## [`ncduu`](./.bin/ncduu)

A simple wrapper around `ncdu`. It deals with result caching in `/tmp` automatically.

Usage:
```
ncduu [OPTIONS] [DIRECTORY]
```

Options:
- `--view`: View the existing cache file instead of performing a new scan.
- `--exclude <path>`: Exclude the specified path from the scan. Can be used multiple times.
- `--help`: Display the help information.

Examples:
```bash
# Scan the current directory
ncduu

# Scan a specific directory
ncduu /path/to/directory

# Exclude a specific path from the scan
ncduu /path/to/directory --exclude /path/to/exclude

# View the cached result for the current directory
ncduu --view

# View the cached result for a specific directory
ncduu /path/to/directory --view
```

## [`Tmux Session Manager (tsm)`](./.bin/tsm)

`tsm` is a powerful command-line tool for managing tmux sessions efficiently. It combines session listing, killing, and popup functionality in one convenient script.

### Features

- List all unique tmux session names
- Kill tmux sessions by base name
- Create or attach to floating popup sessions
- Integrated help system for easy usage

### Usage

```bash
tsm <command> [options]
```

#### Commands

- `list`: List all unique session names
- `kill <session>`: Kill all sessions with the given base name
- `popup [command]`: Create or attach to a floating popup session
- `help [command]`: Display help information for tsm or a specific command

### Examples

#### List all sessions

```bash
tsm list
```

#### Kill a session

```bash
tsm kill mysession
```

This will terminate all sessions that match the name "mysession", including both regular and floating sessions.

#### Create or attach to a floating popup session

The `popup` command in `tsm` is a unique feature that sets it apart from standard tmux session management. It creates and manages special "floating" popup sessions that offer several advantages:

1. **Persistence**: Everything you do in these popup sessions is persistent across tmux restarts.
2. **Context-Awareness**: Each popup session is tied to the tmux window it was created from, allowing for context-specific popups.
3. **Automatic Management**: The script handles creation, attachment, and window management automatically.

##### Why `tsm`?

I developed `tsm` to address limitations in existing tmux session management tools:

1. **Unified Popup and Session Management**: Most tools don't integrate popup functionality with session management. `tsm` brings these together seamlessly.
2. **Smart Session Naming**: `tsm` uses a naming convention that allows for multiple floating sessions tied to different contexts, yet presents them as a single entity for easier management.
3. **Intelligent Process Handling**: When launching a program in a popup, `tsm` checks if it's already running and switches to it instead of creating duplicates.


```bash
# Launch a tmux popup with a persistent session
tsm popup

# Launch a tmux popup with lazygit
tsm popup lazygit

# Launch a tmux popup with htop
tsm popup htop
```

The `popup` command automatically instantiates a tmux popup with a mounted special session for that popup. Everything you do in the tmux popup will be persistent. If the panel is already launched, it won't create a duplicate panel.

#### Display help

```bash
# General help
tsm help

# Help for a specific command
tsm help popup
```

### Tmux Configuration

To integrate `tsm` with your tmux configuration, you can add the following bindings to your `tmux.conf`:

```tmux
# Remove sessions
bind-key r run-shell "echo $(tsm list | fzf-tmux -p 55%,60% \
  --no-sort --border-label ' Remove Session ' \
  --prompt '🗑️  ' \
  --header '  Enter to remove session, Esc to cancel' \
  --bind 'enter:execute(tsm kill {})+reload(tsm list)'\
) > /dev/null"

# Attach to sessions
bind-key a run-shell "tsm list | fzf-tmux -p 55%,60% \
  --no-sort --border-label ' Attach to Session ' \
  --prompt '🔗  ' \
  --header '  Enter to attach to session, Esc to cancel' \
  --bind 'enter:execute-silent(tmux switch-client -t {})+abort' \
  --exit-0"
```

These bindings allow you to quickly remove or attach to sessions using fzf within tmux.


## [`wezl`](././.bin/wezl)

A simple layout manager for Wezterm.

Usage:

```bash
wezl [OPTIONS] LAYOUT_STRING
```

Options:
- `-n, --new-window`: Create layout in a new window
- `-c, --cwd <DIRECTORY>`: Specify the current working directory
- `-h, --help`: Show this help message

Layout string syntax:
- `|` - New tab
- `/` - Vertical split
- `=` - Horizontal split

The layout string is executed in sequence, meaning each character is applied sequentially to create the desired layout.

Examples:

```bash
wezl '||=//='
wezl --new-window --cwd /path/to/directory '||=//='
```

Note: The wezl tool is a script and requires Wezterm to be installed and configured properly.

## [ptt-login](./.bin/ptt-login)

This script provides an easy way to automatically log in to the PTT BBS (Bulletin Board System).

### Installation

1. Ensure you have `expect` installed on your system.
2. Save the script as `ptt-login` in a directory in your PATH (e.g., `/usr/local/bin/`).
3. Make the script executable:
   ```bash
   chmod +x /path/to/ptt-login
   ```
4. Create a directory for profiles:
   ```bash
   mkdir -p ~/.ptt
   ```

### Usage

```bash
ptt-login [OPTIONS] <profile_name | username password>
```

#### Options:

- `-h, --help`: Display help message
- `-k, --keep`: Keep existing connection (default is to disconnect)

#### Arguments:

- `<profile_name>`: Name of the profile in ~/.ptt/ directory
- `<username>`: PTT username (if not using a profile)
- `<password>`: PTT password (if not using a profile)

### Examples

1. Using a profile:
   ```
   ptt-login myprofile
   ```

2. Using a profile and keeping existing connections:
   ```
   ptt-login -k myprofile
   ```

3. Providing username and password directly:
   ```
   ptt-login username password
   ```

4. Providing username and password and keeping existing connections:
   ```
   ptt-login -k username password
   ```

### Profiles

Profiles are stored in the `~/.ptt/` directory. Each profile is a text file containing:

```bash
username
password
keep_connection_flag
```

The `keep_connection_flag` is optional (0 to disconnect existing sessions, 1 to keep them).

### Security Considerations

1. Ensure that your `~/.ptt` directory and profile files have restricted permissions:
   ```bash
   chmod 700 ~/.ptt
   chmod 600 ~/.ptt/*
   ```
2. Be cautious when using command-line arguments for credentials, as they may be visible in your shell history or to other users via the `ps` command.

### Troubleshooting

If you encounter issues:
1. Ensure you have the latest version of the script.
2. Check that your profile files are correctly formatted.
3. Verify that you have the necessary permissions to execute the script and read the profile files.

For further assistance, please open an issue on the project's repository.
