# Startup script

## Dependencies

* `cargo install kb-remap`
* `brew install lunchy-go`

## Usage

```bash
lunchy install ./startup/com.user.startup.plist
```

### OpenCode service

```bash
# ensure /usr/local/bin/opencode exists (symlink to ~/.bun/bin/opencode)
lunchy install ./startup/com.user.opencode.plist
```
Logs: `/tmp/opencode.log` and `/tmp/opencode.err`.
