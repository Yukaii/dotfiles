# Herdr

Stow the command and Herdr packages, then install the sessionizer and link the
local Kakoune popup plugin once per machine:

```sh
stow bin herdr
herdr plugin install salkhalil/herdr-sessionizer --yes
herdr plugin link "$HOME/.config/herdr/plugins-src/kakoune-popup" --enabled
herdr server reload-config
```
