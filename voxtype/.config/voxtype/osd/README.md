# voxtype-osd

A tiny native macOS overlay for [Voxtype](https://github.com/peteonrails/voxtype). One Swift file, built with `swiftc`, using only system frameworks.

- Floating translucent pill, visible across Spaces and fullscreen apps.
- Pulsing recording indicator and live audio waveform.
- Spinner while transcribing.
- **× button or Escape** to cancel recording or transcription without output, without taking keyboard focus from your app.
- Automatically hides when the daemon returns to idle.

This is a display and control companion. Voxtype handles recording, transcription, hotkeys, and text output.

## Preview

| Listening | Transcribing |
| --- | --- |
| <img src="assets/listening.png" alt="Listening overlay with red audio bars and a cancel button" width="276"> | <img src="assets/transcribing.png" alt="Transcribing overlay with a spinner and a cancel button" width="276"> |

Screenshots of the native panel using simulated states and audio level; no microphone recording was used.

## Requirements

- macOS 13 or later.
- Xcode Command Line Tools (`xcode-select --install`).
- A working macOS Voxtype daemon that exposes the interfaces below. Tested with the macOS build of Voxtype **1.0.1** from peteonrails/voxtype, on Apple Silicon.

The build targets your Mac's architecture. Intel builds are not yet tested. This project is independent of Voxtype; compatibility with every release is not guaranteed.

## Build

```sh
git clone https://github.com/Yukaii/voxtype-osd.git
cd voxtype-osd
./build.sh
```

The executable is `build/voxtype-osd`. Building does not install or restart anything.

## Install (recommended)

Run the helper as its **own** process, not as a child of Voxtype.app:

```sh
./build.sh --install-agent
```

This:

1. Installs `~/.local/bin/voxtype-osd`
2. Loads LaunchAgent `io.voxtype.osd` (starts at login, restarts if it exits)

Then disable Voxtype's bundled helper so it does not spawn a second overlay. In `~/.config/voxtype/config.toml`:

```toml
state_file = "auto"

[osd]
enabled = false
```

Restart Voxtype using your normal launcher. Grant **Accessibility** to `~/.local/bin/voxtype-osd` in **System Settings → Privacy & Security → Accessibility** (the first Escape while recording may prompt). Restart the LaunchAgent after granting:

```sh
launchctl kickstart -k "gui/$(id -u)/io.voxtype.osd"
```

The × button works without Accessibility. Escape needs it, because the overlay never takes keyboard focus.

Logs: `~/Library/Logs/voxtype/osd.stderr.log`.

### Why not install into Voxtype.app?

`--install-app` replaces `/Applications/Voxtype.app/Contents/MacOS/voxtype-osd`. Do not use it if you want Escape.

A helper living inside Voxtype.app is attributed by TCC to **Voxtype** (`responsible_path` = `voxtype-bin`). The Accessibility prompt says "Voxtype", the grant is stored for `io.voxtype.daemon`, and `AXIsProcessTrusted()` in the helper stays false. Global key monitors then receive nothing. A LaunchAgent process owns its own identity (`io.voxtype.osd`), so the grant matches.

## How it works

The current implementation expects:

| Interface | Purpose |
| --- | --- |
| `/tmp/voxtype/state` | Plain text `idle`, `recording`, or `transcribing`; polled every 50 ms. |
| `/tmp/voxtype/audio.sock` | Unix stream of 16-byte native-endian frames: `UInt32 seq`, `Float32 min`, `Float32 max`, `Float32 peakDbfs`. |
| `voxtype record cancel` | Cancels recording or transcription and discards output. |

These paths are currently fixed in `main.swift`. A custom state path or runtime directory must match the source. The overlay uses the latest audio level for five animated bars, rather than rendering recorded audio samples.

Cancellation looks for `voxtype-bin` beside the OSD executable, then `~/.local/bin/voxtype`, then the mise shim at `~/.local/share/mise/shims/voxtype`, then `voxtype` on `PATH`. It runs the command asynchronously and waits for daemon state changes before hiding.

Escape is monitored only while recording or transcribing. The global monitor observes key events without consuming them, so the focused app also receives Escape. Held-key repeats and modified shortcuts such as ⌘Esc are ignored.

The OSD uses AppKit and Core Animation, with no package dependencies, webview, or separate service. It does not request microphone access itself.

## Development

Edit `main.swift`, run `./build.sh`, and exercise recording, transcription, and cancellation against your daemon. Check that the original app retains keyboard focus, canceled text is not inserted, and idle hides the panel.

After `--install-agent`, rebuild with `./build.sh --install-agent`. macOS may ask you to re-approve Accessibility after a rebuild.

Extracted from [Yukaii/dotfiles](https://github.com/Yukaii/dotfiles/tree/macos-m3/voxtype/.config/voxtype/osd).

## License

MIT — see [LICENSE](LICENSE).
