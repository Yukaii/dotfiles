# Startup script

## Dependencies

* `cargo install kb-remap`
* `brew install lunchy-go` (only for the other services below)

## Usage

```bash
stow -n -v startup
stow startup
bash startup/install.sh
```

The installer fills in the current home directory in the plist template and
loads a user LaunchAgent. Run it again after changing the plist. The script
resolves `kb-remap` without relying on shell startup files, applies Caps Lock ↔
Left Control to the Apple Internal Keyboard / Trackpad and the Keyboard K380,
and exits immediately after success. At login it makes up to 13 attempts, five
seconds apart, to allow the keyboards to become ready. Keyboards that are not
connected are skipped, so an absent K380 does not fail the run. There is no
recurring schedule or reconnect handling. Successful runs are silent. Run
`bash ~/.startup.sh` manually if you need to reapply the mapping later.

```bash
launchctl print "gui/$(id -u)/com.user.startup"
cat ~/Library/Logs/com.user.startup.err
# Run immediately:
launchctl kickstart "gui/$(id -u)/com.user.startup"
# Stop the service (until next login):
launchctl bootout "gui/$(id -u)/com.user.startup"
```

Logs: `~/Library/Logs/com.user.startup.err`. A `not running` state after
completion is normal; `last exit code = 0` means the run succeeded.

### OpenCode service

```bash
# ensure /usr/local/bin/opencode exists (symlink to ~/.bun/bin/opencode)
lunchy install ./startup/com.user.opencode.plist
```
Logs: `/tmp/opencode.log` and `/tmp/opencode.err`.

### Codex app-server

```bash
# ensure codex is installed at ~/.bun/bin/codex
lunchy install ./startup/com.user.codex-app-server.plist
```
Logs: `/tmp/codex-app-server.log` and `/tmp/codex-app-server.err`.
