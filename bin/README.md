# Some useful shell script I made

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

## [`tmux-popup`](././.bin/tmux-popup)

A wrapper for tmux popup. It automatically instantiates a tmux popup with a mounted special session for that popup. Everything you do in the tmux popup will be persistent.

It also accepts launching programs as arguments, such as lazygit. If the panel is already launched, it won't create a duplicate panel.

Example usage:

```bash
# Launch a tmux popup with a persistent session
tmux-popup

# Launch a tmux popup with lazygit
tmux-popup lazygit

# Launch a tmux popup with htop
tmux-popup htop
```

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
