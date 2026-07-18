#!/bin/bash
# neoOS Quick Start Script
# This script can be run on a fresh Fedora installation to set up Hyprland

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║         neoOS Quick Start                    ║"
echo "║     Set up Hyprland in minutes               ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run this script as root${NC}"
    exit 1
fi

# Check if Fedora
if ! grep -q "Fedora" /etc/os-release; then
    echo -e "${RED}Error: This script is designed for Fedora${NC}"
    exit 1
fi

# Install git if not present
echo -e "${YELLOW}Installing git...${NC}"
sudo dnf install -y git

# Clone repository
echo -e "${YELLOW}Cloning neoOS repository...${NC}"
git clone https://github.com/yourusername/neoOS-hyprland.git ~/neoOS-hyprland
cd ~/neoOS-hyprland

# Make installer executable
chmod +x install.sh

# Run installer
echo -e "${YELLOW}Running installer...${NC}"
./install.sh

echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════╗"
echo "║         Setup Complete!                       ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${GREEN}neoOS Hyprland has been installed successfully!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Reboot your system: ${CYAN}sudo reboot${NC}"
echo "2. Select Hyprland session in SDDM"
echo "3. Run ${CYAN}neoos-rice${NC} to choose your theme"
echo ""
echo -e "${YELLOW}Keybindings:${NC}"
echo "  SUPER + Return    : Open terminal"
echo "  SUPER + D         : Application launcher"
echo "  SUPER + Q         : Close window"
echo "  SUPER + F         : Fullscreen"
echo "  SUPER + V         : Toggle floating"
echo "  SUPER + 1-9       : Switch workspace"
echo ""
echo -e "${GREEN}Enjoy your new neoOS experience!${NC}"
