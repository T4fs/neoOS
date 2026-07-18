#!/bin/bash
# neoOS Hyprland Installer
# Automated installation of Hyprland with popular ricing options

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
NEOOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
RICE_DIR="$NEOOS_DIR/themes"
BACKUP_DIR="$HOME/.config/neoos_backup_$(date +%Y%m%d_%H%M%S)"

# Logging
LOG_FILE="/tmp/neoos-install.log"
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Check if Fedora
check_fedora() {
    if ! grep -q "Fedora" /etc/os-release; then
        log "${RED}Error: This installer is designed for Fedora${NC}"
        exit 1
    fi
}

# Enable COPR repos needed for Hyprland
enable_repos() {
    log "${YELLOW}Enabling required repositories...${NC}"
    
    sudo dnf install -y dnf-plugins-core
    
    sudo dnf copr enable -y solopasha/hyprland
    
    log "${GREEN}Repositories enabled${NC}"
}

# Install dependencies
install_dependencies() {
    log "${YELLOW}Installing dependencies...${NC}"
    
    sudo dnf update -y
    
    # Core Hyprland packages
    sudo dnf install -y \
        hyprland \
        hyprpaper \
        hyprlock \
        hypridle \
        xdg-desktop-portal-hyprland \
        hyprpolkitagent \
        uwsm \
        kitty \
        waybar \
        rofi-wayland \
        swaync \
        wlogout \
        grim \
        slurp \
        wl-clipboard \
        cliphist \
        brightnessctl \
        playerctl \
        polkit-gnome \
        thunar \
        btop \
        fastfetch \
        neovim \
        git \
        wget \
        curl \
        htop \
        tmux \
        fzf \
        ripgrep \
        pipewire \
        pipewire-pulseaudio \
        wireplumber \
        pavucontrol \
        NetworkManager \
        NetworkManager-wifi \
        bluez \
        blueman \
        papirus-icon-theme \
        ttf-jetbrains-mono-nerd \
        firefox \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        sddm
    
    # Enable services
    sudo systemctl enable sddm.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
    
    log "${GREEN}Dependencies installed successfully${NC}"
}

# Backup existing configs
backup_configs() {
    log "${YELLOW}Backing up existing configurations...${NC}"
    
    mkdir -p "$BACKUP_DIR"
    
    for dir in hypr waybar rofi kitty swaync; do
        if [ -d "$CONFIG_DIR/$dir" ]; then
            cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
            log "Backed up $dir"
        fi
    done
    
    log "${GREEN}Backup created at: $BACKUP_DIR${NC}"
}

# Install base configuration
install_base_config() {
    log "${YELLOW}Installing base configuration...${NC}"
    
    mkdir -p "$CONFIG_DIR"/{hypr,waybar,rofi,kitty,swaync}
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/Pictures/Wallpapers"
    
    cp -r "$NEOOS_DIR/configs/hypr/"* "$CONFIG_DIR/hypr/"
    cp -r "$NEOOS_DIR/configs/waybar/"* "$CONFIG_DIR/waybar/"
    cp -r "$NEOOS_DIR/configs/rofi/"* "$CONFIG_DIR/rofi/"
    cp -r "$NEOOS_DIR/configs/kitty/"* "$CONFIG_DIR/kitty/"
    cp -r "$NEOOS_DIR/configs/swaync/"* "$CONFIG_DIR/swaync/"
    
    if [ -d "$NEOOS_DIR/configs/scripts" ]; then
        cp -r "$NEOOS_DIR/configs/scripts/"* "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/"*
    fi
    
    log "${GREEN}Base configuration installed${NC}"
}

# Install rice configurations
install_rices() {
    log "${YELLOW}Installing rice configurations...${NC}"
    
    local rice_install_dir="/usr/share/neoos/rices"
    sudo mkdir -p "$rice_install_dir"
    
    if [ -d "$RICE_DIR" ]; then
        sudo cp -r "$RICE_DIR/"* "$rice_install_dir/"
        log "Installed $(ls -1 "$RICE_DIR" | wc -l) rice configurations"
    fi
    
    log "${GREEN}Rice configurations installed${NC}"
}

# Install theme switcher
install_theme_switcher() {
    log "${YELLOW}Installing theme switcher...${NC}"
    
    cat > "$HOME/.local/bin/neoos-rice" << 'RICE_EOF'
#!/bin/bash
RICE_DIR="/usr/share/neoos/rices"
CONFIG_DIR="$HOME/.config"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

show_menu() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗"
    echo "║         neoOS Rice Selector                  ║"
    echo "║     Choose Your Hyprland Theme               ║"
    echo -e "╚══════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${YELLOW}1)${NC} Catppuccin Mocha"
    echo -e "  ${YELLOW}2)${NC} Tokyo Night"
    echo -e "  ${YELLOW}3)${NC} Gruvbox Dark"
    echo -e "  ${YELLOW}4)${NC} Dracula"
    echo -e "  ${YELLOW}5)${NC} Rose Pine"
    echo -e "  ${YELLOW}6)${NC} Nord"
    echo -e "  ${YELLOW}7)${NC} One Dark"
    echo -e "  ${YELLOW}8)${NC} Kanagawa"
    echo -e "  ${RED}0)${NC} Exit"
    echo ""
}

apply_rice() {
    local rice_name=$1
    local rice_dir="$RICE_DIR/$rice_name"
    
    if [ ! -d "$rice_dir" ]; then
        echo -e "${RED}Error: Rice '$rice_name' not found${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Applying $rice_name...${NC}"
    
    for dir in hypr waybar rofi kitty swaync; do
        if [ -d "$rice_dir/$dir" ]; then
            rm -rf "$CONFIG_DIR/$dir"
            cp -r "$rice_dir/$dir" "$CONFIG_DIR/"
        fi
    done
    
    if command -v hyprctl &> /dev/null; then
        hyprctl reload
    fi
    
    echo -e "${GREEN}Done! Theme applied.${NC}"
}

while true; do
    show_menu
    read -p "Select (0-8): " choice
    
    case $choice in
        0) exit 0 ;;
        1) apply_rice "catppuccin-mocha"; read -p "Press Enter...";;
        2) apply_rice "tokyo-night"; read -p "Press Enter...";;
        3) apply_rice "gruvbox-dark"; read -p "Press Enter...";;
        4) apply_rice "dracula"; read -p "Press Enter...";;
        5) apply_rice "rose-pine"; read -p "Press Enter...";;
        6) apply_rice "nord"; read -p "Press Enter...";;
        7) apply_rice "one-dark"; read -p "Press Enter...";;
        8) apply_rice "kanagawa"; read -p "Press Enter...";;
        *) echo -e "${RED}Invalid${NC}"; sleep 1;;
    esac
done
RICE_EOF

    chmod +x "$HOME/.local/bin/neoos-rice"
    
    log "${GREEN}Theme switcher installed${NC}"
}

# Main installation
main() {
    log "${CYAN}╔══════════════════════════════════════════════╗"
    log "║         neoOS Hyprland Installer             ║"
    log "╚══════════════════════════════════════════════╝${NC}"
    
    check_fedora
    
    echo ""
    read -p "Continue with installation? (y/n): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log "${RED}Installation cancelled.${NC}"
        exit 1
    fi
    
    enable_repos
    install_dependencies
    backup_configs
    install_base_config
    install_rices
    install_theme_switcher
    
    log ""
    log "${GREEN}╔══════════════════════════════════════════════╗"
    log "║         Installation Complete!                ║"
    log "╚══════════════════════════════════════════════╝${NC}"
    log ""
    log "${YELLOW}Next steps:${NC}"
    log "1. Reboot: ${CYAN}sudo reboot${NC}"
    log "2. Select Hyprland in SDDM"
    log "3. Run ${CYAN}neoos-rice${NC} to pick a theme"
    log ""
}

main "$@"
