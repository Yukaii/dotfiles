# Dotfiles

This is [Yukai](https://github.com/Yukaii)'s dotfiles.

## Usage

Install [Homebrew](https://brew.sh/) first, then run `brew bundle` command to install all homebrew dependencies:

```bash
cd homebrew
brew bundle
```

And recover everything with [GNU stow](https://www.gnu.org/software/stow/):

```bash
git clone https://github.com/Yukaii/dotfiles ~/dotfiles --recursive
cd dotfiles
stow vim neovim # ...
```

## Available configs

* bin
* neovim
* vim
* ruby
* tmux
* termite
* editorconfig
