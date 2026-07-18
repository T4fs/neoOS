#!/bin/bash
# neoOS ISO Build Script
# Build a custom Fedora ISO with Hyprland

set -e

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
ISO_NAME="neoOS-Hyprland"
ISO_VERSION=$(date +%Y%m%d)
ISO_LABEL="neoOS-Hyprland-$ISO_VERSION"
BUILD_DIR="/tmp/neoos-build"
ISO_DIR="$BUILD_DIR/iso"

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════╗"
echo "║         neoOS ISO Builder                    ║"
echo "║     Build custom Fedora ISO                  ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root${NC}"
    echo "Usage: sudo ./build-iso.sh"
    exit 1
fi

# Check if required packages are installed
echo -e "${YELLOW}Checking dependencies...${NC}"

REQUIRED_PACKAGES=("livecd-tools" "pykickstart" "git" "wget" "xorriso" "squashfs-tools")
MISSING_PACKAGES=()

for package in "${REQUIRED_PACKAGES[@]}"; do
    if ! rpm -q "$package" &> /dev/null; then
        MISSING_PACKAGES+=("$package")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    echo -e "${YELLOW}Installing missing packages...${NC}"
    dnf install -y "${MISSING_PACKAGES[@]}"
fi

# Create build directory
echo -e "${YELLOW}Creating build directory...${NC}"
rm -rf "$BUILD_DIR"
mkdir -p "$ISO_DIR"

# Download Fedora base
echo -e "${YELLOW}Downloading Fedora base...${NC}"
FEDORA_VERSION=44
FEDORA_URL="https://dl.fedoraproject.org/pub/fedora/linux/releases/$FEDORA_VERSION/Everything/x86_64/os/"

# Create kickstart file
echo -e "${YELLOW}Creating kickstart file...${NC}"
cp "$NEOOS_DIR/kickstarts/neoos-hyprland.ks" "$BUILD_DIR/neoos-hyprland.ks"

# Flatten kickstart
echo -e "${YELLOW}Flattening kickstart...${NC}"
ksflatten --config "$BUILD_DIR/neoos-hyprland.ks" -o "$BUILD_DIR/flat-neoos-hyprland.ks" --version $FEDORA_VERSION

# Build ISO
echo -e "${YELLOW}Building ISO (this may take a while)...${NC}"

# Disable SELinux for ISO building
setenforce 0

# Build live ISO
livemedia-creator \
    --ks "$BUILD_DIR/flat-neoos-hyprland.ks" \
    --no-virt \
    --resultdir "$BUILD_DIR" \
    --project "$ISO_NAME" \
    --make-iso \
    --volid "$ISO_LABEL" \
    --iso-only \
    --iso-name "$ISO_LABEL.iso" \
    --releasever $FEDORA_VERSION \
    --title "$ISO_NAME" \
    --macboot

# Re-enable SELinux
setenforce 1

# Copy ISO to current directory
echo -e "${YELLOW}Copying ISO to current directory...${NC}"
cp "$BUILD_DIR/$ISO_LABEL.iso" "$NEOOS_DIR/"

# Cleanup
echo -e "${YELLOW}Cleaning up...${NC}"
rm -rf "$BUILD_DIR"

echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════╗"
echo "║         ISO Build Complete!                   ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${GREEN}ISO built successfully!${NC}"
echo ""
echo -e "${YELLOW}ISO location:${NC}"
echo "  ${CYAN}$NEOOS_DIR/$ISO_LABEL.iso${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Create bootable USB: ${CYAN}sudo dd if=$ISO_LABEL.iso of=/dev/sdX bs=4M status=progress${NC}"
echo "2. Boot from USB"
echo "3. Install neoOS"
echo ""
echo -e "${GREEN}Enjoy your new neoOS!${NC}"
