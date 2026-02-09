#!/bin/bash

################################################################################
# VMware Module Fix Script for Ubuntu
# This script helps fix VMware vmmon and vmnet module issues on Ubuntu
# by installing Grub Customizer and helping select a compatible kernel
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run this script as root or with sudo"
    exit 1
fi

# Display current kernel
print_info "Current kernel version: $(uname -r)"

# Check if running on Ubuntu
if [ ! -f /etc/os-release ]; then
    print_error "Cannot detect OS. This script is designed for Ubuntu."
    exit 1
fi

source /etc/os-release
if [ "$ID" != "ubuntu" ]; then
    print_error "This script is designed for Ubuntu. Detected: $ID"
    exit 1
fi

print_info "Detected Ubuntu $VERSION"

# List installed kernels
print_info "Installed kernels:"
dpkg --list | grep linux-image | grep -v linux-image-generic | awk '{print "  - " $2}'

# Check for stable kernel (6.8.x)
STABLE_KERNELS=$(dpkg --list | grep linux-image-6.8 | grep -v linux-image-generic | awk '{print $2}')

if [ -z "$STABLE_KERNELS" ]; then
    print_warning "No 6.8.x kernel found. You may need to install one manually."
    print_info "Suggested command: sudo apt install linux-image-6.8.0-100-generic"
    read -p "Do you want to continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    print_info "Found compatible kernel(s):"
    echo "$STABLE_KERNELS" | while read kernel; do
        echo "  - $kernel"
    done
fi

# Install Grub Customizer
print_info "Installing Grub Customizer..."

# Add repository
if ! grep -q "danielrichter2007/grub-customizer" /etc/apt/sources.list.d/*; then
    print_info "Adding Grub Customizer repository..."
    add-apt-repository ppa:danielrichter2007/grub-customizer -y
else
    print_info "Grub Customizer repository already added"
fi

# Update package list
print_info "Updating package list..."
apt update

# Install grub-customizer
if ! dpkg -l | grep -q grub-customizer; then
    print_info "Installing grub-customizer..."
    apt install grub-customizer -y
else
    print_info "Grub Customizer already installed"
fi

print_info "Grub Customizer installed successfully!"

# Provide instructions
echo ""
print_info "==================================================================="
print_info "Next Steps:"
print_info "==================================================================="
echo "1. Run 'sudo grub-customizer' to open Grub Customizer"
echo "2. Find 'Ubuntu, with Linux 6.8.0-100-generic' (or similar stable kernel)"
echo "3. Select it and use the UP arrow to move it to the top"
echo "4. Save and close Grub Customizer"
echo "5. Reboot your system: 'sudo reboot'"
echo "6. After reboot, verify with: 'uname -r'"
echo "7. Start VMware Workstation"
echo ""

# Ask if user wants to open grub-customizer now
read -p "Do you want to open Grub Customizer now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Launching Grub Customizer..."
    grub-customizer &
    print_info "Grub Customizer launched. Follow the instructions above."
else
    print_info "You can run 'sudo grub-customizer' later when ready."
fi

print_info "Script completed successfully!"
