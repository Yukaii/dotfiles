# Deno Global Packages Manager

Scripts to manage globally installed Deno packages.

This package is the Deno-managed counterpart to `bun/`. The `bun/` directory is
left untouched as requested.

## `packages.txt`

`packages.txt` is the managed source of truth. Each line should be a Deno global
install target, typically an `npm:` or `jsr:` specifier.

### Notes

- The current list was converted from `bun/packages.txt`.
- `codex-plusplus@github:b-nnett/codex-plusplus#2ed655a` was intentionally not
  converted because it is a GitHub dependency, not a plain `npm:` specifier.

## `install.sh`

Reads `packages.txt` and installs each entry with Deno global install.

### Usage

```sh
./install.sh
```

### Notes

- The script uses `deno install -g --allow-all` so npm CLIs can run without
  per-package permission curation.
- This is the closest practical Deno equivalent to the previous Bun-based global
  package workflow.

## `dump.sh`

Rebuilds `packages.txt` from currently installed Deno global wrapper scripts.

### Usage

```sh
./dump.sh
```

### Notes

- By default, this reads from `~/.deno/bin`.
- If you use a custom install root, set `DENO_INSTALL_ROOT` before running the
  script.
- The script preserves pinned versions when they are available from Deno's per-
  install metadata.

## `update.sh`

Reinstalls every entry from `packages.txt` with `--force` to refresh the global
install wrappers and package versions.

### Usage

```sh
./update.sh
```

## Prerequisites

- Deno must be installed.
- Make scripts executable:

```sh
chmod +x install.sh dump.sh
```
