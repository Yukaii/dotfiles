# Repository Guidelines

This repository contains dotfiles managed with GNU Stow. Each top‑level folder represents a “package” that mirrors its destination under `$HOME` (e.g., `tmux/.tmux.conf`, `neovim/.config/nvim/…`). Use Stow to symlink only what you need.

## Project Structure & Module Organization
- Packages: one directory per tool (e.g., `zsh`, `tmux`, `neovim`, `wezterm`, `ghostty`).
- Scripts: helper utilities in `bin/.bin` and docs in `bin/README.md`.
- Homebrew: `homebrew/Brewfile` and usage in `homebrew/README.md`.
- Secrets/locals: place machine‑specific or sensitive files in `.storage/` (git‑ignored). Use `stow/.stow-global-ignore` to exclude non‑portable files.

## Build, Test, and Development Commands
- Clone with submodules: `git clone --recursive … ~/dotfiles`
- Update submodules: `git submodule update --init --recursive`
- Stow packages (from repo root): `stow zsh tmux neovim`
- Dry‑run changes: `stow -n -v <pkg>`; Unstow: `stow -D <pkg>`; Restow: `stow -R <pkg>`
- Target a different home: `stow -t "$HOME" <pkg>` when not in `~/dotfiles`.
- Restore Homebrew: `cd homebrew && brew bundle`
- Script benchmark example: `scripts/test-shell-spawn-time.sh 20 zsh`

## Coding Style & Naming Conventions
- Directory names: lowercase tool names; mirror real target paths under each package.
- Shell scripts: prefer `bash`, 2‑space indent, `shellcheck` clean. Format with `shfmt -i 2` when available.
- Lua/YAML/TOML: follow upstream conventions; keep 2‑space indent unless the tool enforces otherwise.
- Keep changes minimal, portable, and free of machine‑specific values.

## Testing Guidelines
- Validate symlinks with `stow -n -v <pkg>` before applying.
- For shell scripts, run `shellcheck` and manual smoke tests.
- After stowing, launch the affected tool to confirm no startup errors (e.g., open tmux/Neovim/terminal emulator and verify).

## Commit & Pull Request Guidelines
- Commit style: Conventional Commits with scoped packages (e.g., `chore(neovim): tweak colorizer`, `refactor(tmux): move helpers`).
- PRs should include: purpose/summary, affected packages, steps to verify (commands used, `stow -n` output if relevant), and linked issues.
- Do not commit secrets or host‑specific tokens; use `.storage/` or local overrides excluded by `.stow-global-ignore`.

## Security & Configuration Tips
- Review diffs for unintentional secrets before pushing.
- Prefer environment variables or separate local files (ignored) for tokens/credentials.
