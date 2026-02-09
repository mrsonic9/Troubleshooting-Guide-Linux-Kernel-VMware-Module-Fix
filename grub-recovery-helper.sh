#!/bin/bash

################################################################################
# GRUB Recovery Instructions Script
# This script provides interactive instructions for recovering GRUB bootloader
################################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_step() {
    echo -e "${GREEN}[STEP $1]${NC} $2"
}

print_command() {
    echo -e "${YELLOW}   Command:${NC} $1"
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Main script
clear
print_header "GRUB RECOVERY HELPER"
echo ""

print_warning "This script is for informational purposes only."
print_warning "If your system is stuck at GRUB prompt, follow these instructions:"
echo ""

print_step "1" "Access the GRUB Menu"
echo "   - Restart your computer"
echo "   - Press 'Shift + Esc' repeatedly during boot"
echo "   - You should see the GRUB menu or GRUB prompt"
echo ""

print_step "2" "Identify Your Boot Partition"
echo "   At the GRUB prompt, type:"
print_command "ls"
echo "   This will show you all available disks, like:"
echo "   (hd0) (hd0,gpt1) (hd0,gpt2) (hd0,gpt5)"
echo ""
echo "   Then check each partition to find your Ubuntu installation:"
print_command "ls (hd0,gpt1)/"
print_command "ls (hd0,gpt2)/"
print_command "ls (hd0,gpt5)/"
echo ""
echo "   Look for a partition that shows /boot/grub or Ubuntu files"
echo ""

print_step "3" "Configure GRUB Boot Parameters"
echo "   Once you find your partition (e.g., hd0,gpt5), type these commands:"
echo ""
print_command "set prefix=(hd0,gpt5)/boot/grub"
print_command "set root=(hd0,gpt5)"
print_command "insmod normal"
print_command "normal"
echo ""
print_warning "IMPORTANT: Replace (hd0,gpt5) with YOUR actual partition!"
echo ""

print_step "4" "Boot into Ubuntu"
echo "   After running the commands, GRUB should show the boot menu"
echo "   Select your Ubuntu entry and press Enter"
echo ""

print_step "5" "After Booting Successfully"
echo "   Once you're back in Ubuntu, fix the kernel issue:"
print_command "sudo ./fix-vmware-modules.sh"
echo "   OR follow the manual instructions in README.md"
echo ""

print_header "COMMON GRUB PARTITIONS"
echo "Common partition layouts:"
echo "  - (hd0,gpt1) - Usually EFI partition"
echo "  - (hd0,gpt2) - Sometimes /boot"
echo "  - (hd0,gpt5) - Often / (root)"
echo "  - (hd0,msdos1) - Legacy MBR systems"
echo ""

print_header "TROUBLESHOOTING TIPS"
echo "1. If 'ls' shows nothing, try:"
print_command "ls (hd0)/"
echo ""
echo "2. If partition has encryption, you may see cryptodisk"
echo "   Try: insmod cryptodisk, then unlock with cryptomount"
echo ""
echo "3. If you still can't boot, try Ubuntu Live USB to repair"
echo ""

print_info "For more help, see README.md or create an issue on GitHub"
echo ""
