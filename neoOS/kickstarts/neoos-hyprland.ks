# neoOS Hyprland - Fedora Kickstart
# Custom Fedora Spin with Hyprland and popular ricing options

lang en_US.UTF-8
keyboard us
timezone UTC
auth --useshadow --passalgo=sha512
selinux --permissive
firewall --disabled
xconfig --startxonboot
zerombr
clearpart --all --initlabel
autopart --type=lt

rootpw --plaintext neoos
user --name=neo --password=neo --plaintext

repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f$releasever&arch=$basearch

# Hyprland COPR repo
repo --name=hyprland --baseurl=https://copr-be.cloud.fedoraproject.org/results/solopasha/hyprland/fedora-$releasever-$basearch/

# Packages
%packages --excludedocs
@base-x
@hardware-support
@multimedia
@standard

# Core Hyprland packages
hyprland
hyprpaper
hyprlock
hypridle
hyprshot
xdg-desktop-portal-hyprland
hyprpolkitagent
uwsm

# Terminal and shell
kitty
zsh
zsh-autosuggestions
zsh-syntax-highlighting
oh-my-zsh

# Bar and launcher
waybar
rofi-wayland
wofi

# Notification and system
swaync
swayosd
wlogout
grim
slurp
wl-clipboard
cliphist
brightnessctl
playerctl
polkit-gnome

# File manager and utilities
thunar
thunar-archive-plugin
yazi
btop
fastfetch
neovim
nano

# Appearance
nordic-theme
papirus-icon-theme
bibata-cursor-theme
ttf-jetbrains-mono-nerd
ttf-firacode-nerd
ttf-cascadia-code-nerd

# Applications
firefox
obsidian
spotify-client
discord
vlc
gimp
libreoffice

# System tools
git
wget
curl
htop
tmux
fzf
ripgrep
fd-find
bat
exa

# Audio
pipewire
pipewire-pulseaudio
wireplumber
pavucontrol

# Network
NetworkManager
NetworkManager-wifi
nm-connection-editor

# Bluetooth
bluez
blueman

# GPU support
mesa-dri-drivers
vulkan-loader
mesa-vulkan-drivers

# Virtualization (optional)
libvirt
qemu-kvm
virt-manager

%end

# Post-install script
%post --log=/root/neoos-post.log
#!/bin/bash

# Enable services
systemctl enable sddm.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable pipewire.service
systemctl enable wireplumber.service

# Set graphical target
systemctl set-default graphical.target

# Create neo user directory structure
su - neo -c '
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/kitty
mkdir -p ~/.config/swaync
mkdir -p ~/.config/neovim
mkdir -p ~/.local/bin
mkdir -p ~/Pictures/Wallpapers
'

# Copy neoOS configuration files
cp -r /etc/neoos/configs/* /home/neo/.config/

# Set ownership
chown -R neo:neo /home/neo/.config
chown -R neo:neo /home/neo/.local

# Create rice selector script
cat > /usr/local/bin/neoos-rice << 'RICE_EOF'
#!/bin/bash
# neoOS Rice Selector
# Choose from popular Hyprland ricing configurations

RICE_DIR="/usr/share/neoos/rices"
CONFIG_DIR="$HOME/.config"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display menu
show_menu() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║         neoOS Rice Selector                  ║"
    echo "║     Choose Your Hyprland Theme               ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}Available Rices:${NC}"
    echo ""
    echo -e "  ${YELLOW}1)${NC} Catppuccin Mocha   - Sweet and warm theme"
    echo -e "  ${YELLOW}2)${NC} Tokyo Night        - Dark and vibrant theme"
    echo -e "  ${YELLOW}3)${NC} Gruvbox Dark       - Retro groove theme"
    echo -e "  ${YELLOW}4)${NC} Dracula            - Dark theme for the night"
    echo -e "  ${YELLOW}5)${NC} Rose Pine          - All-natural pine cone theme"
    echo -e "  ${YELLOW}6)${NC} Nord               - Arctic, north-bluish theme"
    echo -e "  ${YELLOW}7)${NC} One Dark           - Atom One Dark theme"
    echo -e "  ${YELLOW}8)${NC} Kanagawa           - Japanese wave theme"
    echo -e "  ${YELLOW}9)${NC} Everforest         - Comfort green theme"
    echo -e "  ${YELLOW}10)${NC} Material You       - Dynamic wallpaper theme"
    echo ""
    echo -e "  ${RED}0)${NC} Exit"
    echo ""
}

# Function to apply rice
apply_rice() {
    local rice_name=$1
    local rice_dir="$RICE_DIR/$rice_name"
    
    if [ ! -d "$rice_dir" ]; then
        echo -e "${RED}Error: Rice '$rice_name' not found${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Applying $rice_name rice...${NC}"
    
    # Backup current configs
    local backup_dir="$HOME/.config/neoos_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup existing configs
    for dir in hypr waybar rofi kitty swaync; do
        if [ -d "$CONFIG_DIR/$dir" ]; then
            cp -r "$CONFIG_DIR/$dir" "$backup_dir/"
        fi
    done
    
    echo -e "${YELLOW}Backup created at: $backup_dir${NC}"
    
    # Apply new rice configs
    for dir in hypr waybar rofi kitty swaync; do
        if [ -d "$rice_dir/$dir" ]; then
            rm -rf "$CONFIG_DIR/$dir"
            cp -r "$rice_dir/$dir" "$CONFIG_DIR/"
        fi
    done
    
    # Apply GTK theme if exists
    if [ -f "$rice_dir/gtk-3.0/settings.ini" ]; then
        mkdir -p "$CONFIG_DIR/gtk-3.0"
        cp "$rice_dir/gtk-3.0/settings.ini" "$CONFIG_DIR/gtk-3.0/"
    fi
    
    if [ -f "$rice_dir/gtk-4.0/settings.ini" ]; then
        mkdir -p "$CONFIG_DIR/gtk-4.0"
        cp "$rice_dir/gtk-4.0/settings.ini" "$CONFIG_DIR/gtk-4.0/"
    fi
    
    # Apply wallpaper if exists
    if [ -f "$rice_dir/wallpaper" ]; then
        local wallpaper=$(cat "$rice_dir/wallpaper")
        if [ -f "$HOME/Pictures/Wallpapers/$wallpaper" ]; then
            cp "$HOME/Pictures/Wallpapers/$wallpaper" "$CONFIG_DIR/hypr/wallpaper.jpg"
        fi
    fi
    
    # Reload Hyprland
    if command -v hyprctl &> /dev/null; then
        hyprctl reload
        echo -e "${GREEN}Hyprland reloaded with $rice_name theme${NC}"
    fi
    
    echo -e "${GREEN}Rice applied successfully!${NC}"
    echo -e "${YELLOW}You may need to restart some applications for changes to take effect.${NC}"
}

# Main
while true; do
    show_menu
    read -p "Select a rice (0-10): " choice
    
    case $choice in
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        1)
            apply_rice "catppuccin-mocha"
            read -p "Press Enter to continue..."
            ;;
        2)
            apply_rice "tokyo-night"
            read -p "Press Enter to continue..."
            ;;
        3)
            apply_rice "gruvbox-dark"
            read -p "Press Enter to continue..."
            ;;
        4)
            apply_rice "dracula"
            read -p "Press Enter to continue..."
            ;;
        5)
            apply_rice "rose-pine"
            read -p "Press Enter to continue..."
            ;;
        6)
            apply_rice "nord"
            read -p "Press Enter to continue..."
            ;;
        7)
            apply_rice "one-dark"
            read -p "Press Enter to continue..."
            ;;
        8)
            apply_rice "kanagawa"
            read -p "Press Enter to continue..."
            ;;
        9)
            apply_rice "everforest"
            read -p "Press Enter to continue..."
            ;;
        10)
            apply_rice "material-you"
            read -p "Press Enter to continue..."
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 2
            ;;
    esac
done
RICE_EOF

chmod +x /usr/local/bin/neoos-rice

# Create neoOS configuration directory
mkdir -p /etc/neoos/configs
cp -r /home/neo/.config/* /etc/neoos/configs/

# Create rice directory structure
mkdir -p /usr/share/neoos/rices

# Install rice configurations
# This will be populated by the installer script

%end

# Scripts
%post --log=/root/neoos-scripts.log
#!/bin/bash

# Create neoOS first-boot script
cat > /usr/local/bin/neoos-setup << 'SETUP_EOF'
#!/bin/bash
# neoOS First Boot Setup

echo "Welcome to neoOS!"
echo ""
echo "This is your first boot. Let's set up your environment."
echo ""

# Ask for rice selection
echo "Would you like to select a rice configuration now? (y/n)"
read -p "> " choice

if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    neoos-rice
fi

echo ""
echo "Setup complete! Enjoy your new neoOS experience."
echo ""
echo "You can run 'neoos-rice' anytime to change your rice configuration."
SETUP_EOF

chmod +x /usr/local/bin/neoos-setup

# Create systemd service for first boot
cat > /etc/systemd/system/neoos-setup.service << 'SERVICE_EOF'
[Unit]
Description=neoOS First Boot Setup
After=network.target
Wants=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/neoos-setup
User=neo
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICE_EOF

systemctl enable neoos-setup.service

%end
