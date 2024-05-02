# Dotfiles

Hi I'm [Yukai](https://yukai.tw). This is my dotfiles, managed with GNU stow.

## Usage

Install [GNU stow](https://www.gnu.org/software/stow/) first, then clone the repo into home directory:

```bash
git clone https://github.com/Yukaii/dotfiles ~/dotfiles --recursive
```

Now cd into the directory, and restore with stow command:

```bash
cd dotfiles
stow vim neovim # ...
```

If you place `dotfiles` directory other than home directory, you may need extra argument for stow command.

## License

MIT
