# Fancy SketchyBar Configuration

A sophisticated, device-aware SketchyBar setup with modern styling and advanced features.

## Features

### 🔄 Device-Aware Configuration
- **Automatic detection** between laptop (built-in display) and desktop (external display)
- **Laptop mode**: Optimized for MacBook with notch support
- **Desktop mode**: Full-width configuration for external displays

### 🎨 Modern Styling
- **Catppuccin Macchiato** color scheme
- **Rounded corners** and **blur effects**
- **Dynamic color coding** for different widget types
- **Professional typography** with JetBrainsMono Nerd Font

### 📊 Advanced Widgets
- **Current Space**: Dynamic space indicators with custom icons
- **Front App**: App icons with names using sophisticated bracket system
- **Media Controls**: Now playing information with click-to-play/pause
- **System Monitoring**: CPU, memory usage with color-coded alerts
- **Network Speed**: Real-time upload/download speeds (laptop only)
- **Battery**: Intelligent battery monitoring with power source detection
- **Volume**: System volume with change detection
- **Clock**: Formatted date and time display

### 🚀 Performance Optimizations
- **Event-driven updates** for responsive UI
- **Conditional rendering** with `updates=when_shown`
- **Optimized update frequencies** for different widget types
- **Efficient plugin architecture**

## File Structure

```
~/.config/sketchybar/
├── sketchybarrc              # Main entry point (device detection)
├── sketchybarrc-laptop       # Laptop-specific configuration
├── sketchybarrc-desktop      # Desktop-specific configuration
├── colors.sh                 # Color palette definitions
├── plugins/
│   ├── battery.sh           # Battery monitoring
│   ├── clock.sh             # Date/time display
│   ├── cpu.sh               # CPU usage monitoring
│   ├── current_space.sh     # Space indicator
│   ├── front_app.sh         # Active application display
│   ├── icon_map.sh          # Application icon mapping
│   ├── media.sh             # Media controls
│   ├── memory.sh            # Memory usage monitoring
│   ├── network.sh           # Network monitoring
│   ├── network_speed.sh     # Real-time network speeds
│   ├── spotify.sh           # Spotify integration
│   └── volume.sh            # Volume control
```

## Installation

The configuration is already set up. To apply it:

```bash
# Restart SketchyBar to load the new configuration
brew services restart sketchybar
```

## Customization

### Colors
Edit `colors.sh` to change the color scheme:
```bash
export RED=0xffed8796
export GREEN=0xffa6da95
# ... modify as needed
```

### Add New Applications
Edit `plugins/icon_map.sh` to add icons for new applications:
```bash
"Your App") icon_result="󰀶";;
```

### Widget Configuration
Individual widgets can be customized in their respective device-specific files:
- `sketchybarrc-laptop` - For laptop-specific widgets
- `sketchybarrc-desktop` - For desktop-specific widgets

## Dependencies

- **JetBrainsMono Nerd Font**: For icons and typography
- **jq**: For JSON parsing in media controls
- **ifstat**: For network speed monitoring (optional)
- **bc**: For mathematical calculations

Install missing dependencies:
```bash
brew install jq ifstat
brew install --cask font-jetbrains-mono-nerd-font
```