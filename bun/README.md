# Bun Global Packages Manager

Scripts to manage globally installed packages using Bun.

## dump.sh

Dumps the list of globally installed packages to `packages.txt`.

### Usage

```sh
./dump.sh
```

## install.sh

Reads `packages.txt` and reinstalls the listed packages globally.

### Usage

```sh
./install.sh
```

## Prerequisites

- Bun must be installed.
- Make scripts executable:

```sh
chmod +x dump.sh install.sh
```

This setup helps you easily export and import your global Bun packages.
