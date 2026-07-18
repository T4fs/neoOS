# neoOS Hyprland

A custom Fedora-based OS with Hyprland and popular ricing configurations available directly.

## Features

- **Hyprland** - Modern Wayland compositor with animations and blur effects
- **Multiple Rice Options** - Choose from 8+ popular Hyprland themes
- **Easy Theme Switching** - Change themes instantly with `neoos-rice`
- **Pre-configured Applications** - Kitty, Waybar, Rofi, SwayNC, and more
- **Modular Configuration** - Easy to customize and extend

## Available Rices

| Theme | Description |
|-------|-------------|
| **Catppuccin Mocha** | Sweet and warm theme with a cozy aesthetic |
| **Tokyo Night** | Dark and vibrant theme inspired by Tokyo's neon lights |
| **Gruvbox Dark** | Retro groove theme with warm colors |
| **Dracula** | Dark theme for the night |
| **Rose Pine** | All-natural pine cone theme |
| **Nord** | Arctic, north-bluish clean and elegant theme |
| **One Dark** | Atom One Dark theme for code editors |
| **Kanagawa** | Japanese wave theme inspired by ukiyo-e |

## Installation

### Prerequisites

- Fedora 44 (or later)
- Internet connection
- 20GB+ free disk space

### Quick Install

```bash
# Clone the repository
git clone https://github.com/yourusername/neoOS-hyprland.git
cd neoOS-hyprland

# Make installer executable
chmod +x install.sh

# Run installer
./install.sh
```

### Manual Install

```bash
# Install dependencies
sudo dnf install -y hyprland hyprpaper hyprlock hypridle kitty waybar rofi-wayland swaync

# Copy configuration files
cp -r configs/* ~/.config/

# Make scripts executable
chmod +x ~/.local/bin/*

# Enable services
sudo systemctl enable sddm.service
sudo systemctl enable NetworkManager.service
```

## Usage

### Changing Themes

```bash
# Launch theme selector
neoos-rice

# Or apply a specific theme directly
neoos-rice catppuccin-mocha
neoos-rice tokyo-night
neoos-rice gruvbox-dark
```

### Wallpaper Management

```bash
# List available wallpapers
neoos-wallpaper --list

# Select and apply a wallpaper
neoos-wallpaper --select

# Apply a random wallpaper
neoos-wallpaper --random

# Download wallpapers
neoos-wallpaper --download
```

### Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Return` | Open terminal |
| `SUPER + D` | Application launcher |
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + V` | Toggle floating |
| `SUPER + 1-9` | Switch workspace |
| `SUPER + Shift + 1-9` | Move window to workspace |
| `SUPER + P` | Pseudo tiling |
| `SUPER + J/K` | Focus down/up |
| `SUPER + Arrow keys` | Focus navigation |
| `Print` | Screenshot (area) |
| `Shift + Print` | Screenshot (full) |

## Project Structure

```
neoOS-hyprland/
├── configs/                    # Configuration files
│   ├── hypr/                   # Hyprland configs
│   │   ├── hyprland.conf       # Main config
│   │   ├── monitors.conf       # Monitor setup
│   │   ├── keybinds.conf       # Keyboard shortcuts
│   │   ├── appearance.conf     # Visual settings
│   │   ├── rules.conf          # Window rules
│   │   └── autostart.conf      # Autostart apps
│   ├── waybar/                 # Status bar
│   ├── rofi/                   # App launcher
│   ├── kitty/                  # Terminal
│   ├── swaync/                 # Notifications
│   └── scripts/                # Utility scripts
├── themes/                     # Rice configurations
│   ├── catppuccin-mocha/
│   ├── tokyo-night/
│   ├── gruvbox-dark/
│   ├── dracula/
│   ├── rose-pine/
│   ├── nord/
│   ├── one-dark/
│   └── kanagawa/
├── packages/                   # Package lists
│   ├── core.txt
│   └── optional.txt
├── kickstarts/                 # Fedora kickstart files
├── install.sh                  # Main installer
└── README.md
```

## Customization

### Adding a New Theme

1. Create a new directory in `themes/`
2. Add theme configuration files:
   - `theme.conf` - Theme metadata and colors
   - `hypr/appearance.conf` - Hyprland colors
   - `kitty/kitty.conf` - Terminal colors
   - `waybar/style.css` - Status bar colors
3. Update the theme switcher in `install.sh`

### Modifying Keybindings

Edit `configs/hypr/keybinds.conf` to customize keyboard shortcuts.

### Adding Applications

Edit `configs/hypr/rules.conf` to add window rules for new applications.

## Troubleshooting

### Theme Not Applied

```bash
# Reload Hyprland
hyprctl reload

# Restart Waybar
killall waybar
waybar &
```

### Wallpaper Not Showing

```bash
# Restart hyprpaper
killall hyprpaper
hyprpaper &
```

### Notifications Not Working

```bash
# Restart SwayNC
killall swaync
swaync &
```

## Credits

- [Hyprland](https://hyprland.org/) - Wayland compositor
- [Catppuccin](https://catppuccin.com/) - Theme collection
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) - Theme
- [Gruvbox](https://github.com/morhetz/gruvbox) - Theme
- [Dracula](https://draculatheme.com/) - Theme
- [Rose Pine](https://rosepinetheme.com/) - Theme
- [Nord](https://www.nordtheme.com/) - Theme
- [One Dark](https://github.com/atom/one-dark-syntax) - Theme
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim) - Theme

## License

MIT License - See [LICENSE](LICENSE) for details.
