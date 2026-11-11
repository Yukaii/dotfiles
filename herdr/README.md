# Herdr

Stow the Herdr package, then install the plugins once per machine:

```sh
stow herdr
herdr plugin install salkhalil/herdr-sessionizer --yes
herdr plugin install Yukaii/herdr-kakoune-popup --ref v0.1.1 --yes
herdr server reload-config
```

The package carries two configs for two products:

- `.config/herdr/config.toml` — the `herdr` TUI.
- `.config/herdr-core/config.toml` — the `hc` core that `herdr-app` and `hc`
  terminals run on. Runtime state lives in `~/.local/state/herdr-core`, so
  `~/.config/herdr-core` stays a plain config directory.

`herdr-app` keeps its own JSON config in `~/.config/herdr-app/`, which is not
managed here.

After stowing, new `hc`/`herdr-app` terminals start the configured shell right
away (`hc run --bg` to check); `hc server restart` is only needed for settings
that the core reads once, such as `socket`.
