# neoOS

### A Fedora Hyprland Setup with Popular Ricing Out of the Box

</div>

---

## What is neoOS?

neoOS is an automated installer that transforms a fresh **Fedora 44** installation into a fully configured **Hyprland** desktop with **8 popular rice configurations** you can switch between instantly. No manual config editing needed — pick a theme, and everything updates: window borders, terminal colors, status bar, app launcher, and notifications.

---

## Screenshots

> *Screenshots coming soon*

---

## Available Rices

| # | Theme | Style | Colors |
|---|-------|-------|--------|
| 1 | **Catppuccin Mocha** | Sweet, warm, cozy | Blue + Purple gradients |
| 2 | **Tokyo Night** | Dark, vibrant, neon | Blue + Purple on deep navy |
| 3 | **Gruvbox Dark** | Retro groove, earthy | Yellow + Pink on dark brown |
| 4 | **Dracula** | Classic dark, moody | Purple + Pink on dark blue |
| 5 | **Rose Pine** | Natural, calm, elegant | Teal + Lavender on deep purple |
| 6 | **Nord** | Arctic, clean, minimal | Blue + Purple on slate |
| 7 | **One Dark** | Code editor classic | Blue + Purple on dark grey |
| 8 | **Kanagawa** | Japanese wave, artistic | Blue + Purple on deep ink |

Each rice includes matching colors for:
- Hyprland window borders and shadows
- Waybar status bar
- Kitty terminal
- Rofi application launcher

---

## What Gets Installed

### Core Components

| Component | Tool | Purpose |
|-----------|------|---------|
| Compositor | Hyprland | Tiling Wayland window manager |
| Wallpaper | Hyprpaper | Wallpaper daemon |
| Lock Screen | Hyprlock | Lock screen with blur |
| Idle Manager | Hypridle | Auto-lock on idle |
| Status Bar | Waybar | Top bar with clock, audio, network, battery |
| App Launcher | Rofi | Keyboard-driven app launcher |
| Terminal | Kitty | GPU-accelerated terminal |
| Notifications | SwayNC | Notification center |
| File Manager | Thunar | Graphical file manager |
| Shell | Zsh | Enhanced shell with syntax highlighting |

### Utilities

| Tool | Purpose |
|------|---------|
| grim + slurp | Screenshot tools |
| wl-clipboard | Clipboard management |
| cliphist | Clipboard history |
| brightnessctl | Screen brightness control |
| playerctl | Media playback control |
| btop | System monitor |
| fastfetch | System info display |
| neovim | Terminal text editor |

### Fonts

- JetBrainsMono Nerd Font
- FiraCode Nerd Font
- Cascadia Code Nerd Font

---

## Requirements

- **OS:** Fedora 44 (minimal install or workstation)
- **Disk:** 10 GB free space
- **RAM:** 4 GB minimum
- **Internet:** Required during installation
- **GPU:** AMD or Intel (Nvidia may need extra config)

---

## Installation

### Step 1: Clone the Repository

```bash
sudo dnf install -y git
git clone https://github.com/YOUR_USERNAME/neoOS.git
cd neoOS
```

### Step 2: Make Installer Executable

```bash
chmod +x install.sh
```

### Step 3: Run Installer

```bash
sudo ./install.sh
```

The installer will:
1. Enable the Hyprland COPR repository
2. Install all required packages
3. Back up any existing configs to `~/.config/neoos_backup_*`
4. Copy base Hyprland configuration
5. Install all 8 rice configurations to `/usr/share/neoos/rices/`
6. Install the `neoos-rice` theme switcher command
7. Enable SDDM login manager

### Step 4: Reboot

```bash
sudo reboot
```

### Step 5: Select Hyprland

At the SDDM login screen, click the session dropdown (top-left or bottom-left) and select **Hyprland**. Log in.

### Step 6: Pick Your Rice

```bash
neoos-rice
```

Choose a number from 1-8 and your entire desktop theme changes instantly.

---

## Usage

### Switching Themes

```bash
neoos-rice
```

This opens an interactive menu. Pick a number and all components update:
- Hyprland border colors
- Waybar colors and styling
- Kitty terminal colors
- Rofi launcher colors

Your previous config is automatically backed up before any change.

### Keybindings

| Key | Action |
|-----|--------|
| `SUPER + Return` | Open Kitty terminal |
| `SUPER + D` | Open Rofi app launcher |
| `SUPER + Q` | Close focused window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + V` | Toggle floating mode |
| `SUPER + P` | Pseudo tiling |
| `SUPER + 1` through `SUPER + 9` | Switch to workspace 1-9 |
| `SUPER + Shift + 1` through `SUPER + Shift + 9` | Move window to workspace 1-9 |
| `SUPER + H/L` | Focus left/right |
| `SUPER + J/K` | Focus down/up |
| `SUPER + Arrow Keys` | Focus navigation |
| `SUPER + Mouse Drag` | Move window |
| `SUPER + Right Mouse` | Resize window |
| `SUPER + Mouse Scroll` | Switch workspaces |
| `Print` | Screenshot area (copies to clipboard) |
| `Shift + Print` | Screenshot full screen |
| `XF86AudioRaise/Lower` | Volume control |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp/Down` | Brightness control |

### Project Structure

```
neoOS/
├── install.sh              # Main installer script
├── README.md               # This file
├── LICENSE                  # MIT License
│
├── configs/                # Base configuration files
│   ├── hypr/               # Hyprland configs
│   │   ├── hyprland.conf   # Main config (imports others)
│   │   ├── monitors.conf   # Monitor/workspace setup
│   │   ├── keybinds.conf   # All keyboard shortcuts
│   │   ├── appearance.conf # Colors, blur, animations
│   │   ├── rules.conf      # Window rules (opacity, floating, etc.)
│   │   └── autostart.conf  # Apps that start with Hyprland
│   │
│   ├── waybar/             # Status bar
│   │   ├── config.jsonc    # Bar modules and layout
│   │   └── style.css       # Bar styling
│   │
│   ├── rofi/               # App launcher
│   │   └── config.rasi     # Launcher config and theme
│   │
│   ├── kitty/              # Terminal
│   │   └── kitty.conf      # Terminal settings
│   │
│   ├── swaync/             # Notification center
│   │   └── config.json     # Notification settings
│   │
│   └── scripts/            # Utility scripts
│       └── neoos-wallpaper # Wallpaper manager
│
├── themes/                 # 8 rice configurations
│   ├── catppuccin-mocha/
│   │   ├── theme.conf          # Theme metadata
│   │   ├── hypr/appearance.conf
│   │   ├── kitty/kitty.conf
│   │   ├── waybar/style.css
│   │   ├── rofi/
│   │   └── swaync/
│   │
│   ├── tokyo-night/
│   │   └── (same structure)
│   ├── gruvbox-dark/
│   ├── dracula/
│   ├── rose-pine/
│   ├── nord/
│   ├── one-dark/
│   └── kanagawa/
│
├── packages/               # Package lists
│   ├── core.txt            # Required packages
│   └── optional.txt        # Recommended extras
│
└── kickstarts/             # Fedora ISO build files
    └── neoos-hyprland.ks   # Kickstart for custom ISO
```

---

## Adding Your Own Rice

1. Create a new directory in `themes/`:
   ```bash
   mkdir themes/my-theme
   ```

2. Create these files inside it:

   **`themes/my-theme/theme.conf`**
   ```
   description = My Custom Theme
   author = Your Name
   accent = #your_accent_color
   wallpaper = my-wallpaper.jpg
   ```

   **`themes/my-theme/hypr/appearance.conf`**
   ```conf
   general {
       col.active_border = rgba(your_accent) rgba(your_accent2) 45deg
       col.inactive_border = rgba(your_bg_variant) rgba(your_bg_variant2) 45deg
   }
   ```

   **`themes/my-theme/kitty/kitty.conf`**
   ```
   foreground #your_text_color
   background #your_bg_color
   color0     #your_black
   color1     #your_red
   ...
   ```

   **`themes/my-theme/waybar/style.css`**
   ```css
   window#waybar {
       background-color: rgba(your_bg, 0.85);
       color: #your_text;
       border: 2px solid rgba(your_accent, 0.3);
   }
   #workspaces button.active { color: #your_accent; }
   ```

3. Add a case to the `neoos-rice` script (inside `install.sh`) or edit `~/.local/bin/neoos-rice` directly.

---

## Troubleshooting

### Hyprland won't start

```bash
# Check if Hyprland is installed
which hyprland

# Try launching from TTY
Hyprland
```

### Theme didn't apply

```bash
# Reload Hyprland
hyprctl reload

# Restart Waybar
killall waybar && setsid waybar &

# Restart notifications
killall swaync && setsid swaync &
```

### No sound

```bash
# Check PipeWire status
systemctl --user status pipewire wireplumber

# Restart audio
systemctl --user restart pipewire wireplumber

# Open audio mixer
pavucontrol
```

### Display manager not showing

```bash
# Re-enable SDDM
sudo systemctl enable sddm
sudo systemctl set-default graphical.target
sudo reboot
```

### WiFi not working

```bash
# Check NetworkManager
sudo systemctl status NetworkManager

# Restart it
sudo systemctl restart NetworkManager
```

---

## Uninstalling

```bash
# Remove installed configs
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/.config/kitty ~/.config/swaync

# Remove theme switcher
rm ~/.local/bin/neoos-rice

# Remove installed rices
sudo rm -rf /usr/share/neoos

# Restore from backup (if exists)
cp -r ~/.config/neoos_backup_*/hypr ~/.config/
```

---

## Credits

| Project | Author |
|---------|--------|
| [Hyprland](https://hyprland.org/) | Vaxry |
| [Catppuccin](https://catppuccin.com/) | Catppuccin Team |
| [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) | Enkia |
| [Gruvbox](https://github.com/morhetz/gruvbox) | morhetz |
| [Dracula](https://draculatheme.com/) | Dracula |
| [Rose Pine](https://rosepinetheme.com/) | Rose Pine |
| [Nord](https://www.nordtheme.com/) | Arctic Ice Studio |
| [One Dark](https://github.com/atom/one-dark-syntax) | Atom |
| [Kanagawa](https://github.com/rebelot/kanagawa.nvim) | rebelot |
| [Waybar](https://github.com/Alexays/Waybar) | Alexays |
| [Rofi](https://github.com/DaveDavenport/rofi) | DaveDavenport |
| [Kitty](https://github.com/kovidgoyal/kitty) | Kovid Goyal |

---

## License

MIT License. See [LICENSE](LICENSE) for details.
