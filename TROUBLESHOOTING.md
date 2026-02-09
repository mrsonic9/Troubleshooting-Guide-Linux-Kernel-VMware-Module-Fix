# Advanced Troubleshooting Guide

This document provides additional troubleshooting steps for VMware module issues on Ubuntu.

## Table of Contents
1. [Common Error Messages](#common-error-messages)
2. [Kernel Compatibility Matrix](#kernel-compatibility-matrix)
3. [Manual VMware Module Compilation](#manual-vmware-module-compilation)
4. [GRUB Advanced Recovery](#grub-advanced-recovery)
5. [Alternative Solutions](#alternative-solutions)

## Common Error Messages

### Error: "Could not compile vmmon module"

**Symptoms:**
```
Failed to build vmmon. Failed to execute the build command.
```

**Solutions:**
1. Use a compatible kernel (6.8.x recommended)
2. Install kernel headers:
   ```bash
   sudo apt install linux-headers-$(uname -r)
   ```
3. Install build essentials:
   ```bash
   sudo apt install build-essential
   ```

### Error: "Unable to install all modules"

**Symptoms:**
```
Unable to install all modules. See log /tmp/vmware-*.log for details.
```

**Solutions:**
1. Check the log file for specific errors
2. Ensure gcc version matches kernel compilation
3. Verify VMware version supports your kernel

### Error: "System stuck at GRUB prompt"

**Symptoms:**
```
grub>
```

**Solution:**
See [GRUB Advanced Recovery](#grub-advanced-recovery) below.

## Kernel Compatibility Matrix

| Kernel Version | VMware Workstation | Status | Notes |
|----------------|-------------------|--------|-------|
| 6.17.x | 17.x | ❌ Incompatible | Known issues |
| 6.8.x | 17.x | ✅ Compatible | Recommended |
| 6.5.x | 17.x | ✅ Compatible | Stable |
| 6.2.x | 16.x, 17.x | ✅ Compatible | Older but stable |
| 5.15.x | 16.x, 17.x | ✅ Compatible | LTS |

**Note:** Compatibility may vary based on specific minor versions.

## Manual VMware Module Compilation

If automatic compilation fails, try manual compilation:

### Step 1: Install Prerequisites
```bash
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r)
```

### Step 2: Download VMware Module Sources
VMware modules are typically in:
```bash
/usr/lib/vmware/modules/source/
```

### Step 3: Extract and Build
```bash
cd /tmp
tar xvf /usr/lib/vmware/modules/source/vmmon.tar
cd vmmon-only
make
sudo make install
```

Repeat for vmnet:
```bash
cd /tmp
tar xvf /usr/lib/vmware/modules/source/vmnet.tar
cd vmnet-only
make
sudo make install
```

### Step 4: Load Modules
```bash
sudo modprobe vmmon
sudo modprobe vmnet
```

### Step 5: Verify
```bash
lsmod | grep vm
```

You should see vmmon and vmnet listed.

## GRUB Advanced Recovery

### Recovery from Live USB

If GRUB recovery from prompt doesn't work:

1. **Boot Ubuntu Live USB**

2. **Mount Your System**
   ```bash
   # Find your root partition
   sudo fdisk -l
   
   # Mount root partition (replace /dev/sda5 with your partition)
   sudo mount /dev/sda5 /mnt
   
   # Mount required filesystems
   sudo mount --bind /dev /mnt/dev
   sudo mount --bind /proc /mnt/proc
   sudo mount --bind /sys /mnt/sys
   
   # If you have separate boot partition, mount it
   sudo mount /dev/sda2 /mnt/boot  # if applicable
   ```

3. **Chroot into Your System**
   ```bash
   sudo chroot /mnt
   ```

4. **Reinstall GRUB**
   ```bash
   # For UEFI systems
   grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu
   
   # For BIOS systems
   grub-install /dev/sda  # replace with your disk
   
   # Update GRUB configuration
   update-grub
   ```

5. **Exit and Reboot**
   ```bash
   exit
   sudo umount -R /mnt
   sudo reboot
   ```

### GRUB Configuration Files

Important GRUB files:
- `/etc/default/grub` - Main configuration
- `/boot/grub/grub.cfg` - Generated configuration (don't edit directly)
- `/etc/grub.d/` - Scripts that generate grub.cfg

To change default kernel in `/etc/default/grub`:
```bash
# Edit the file
sudo nano /etc/default/grub

# Set default entry (0 = first entry)
GRUB_DEFAULT=0

# Or set by menu entry name
GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 6.8.0-100-generic"

# Update GRUB
sudo update-grub
```

## Alternative Solutions

### Solution 1: Use VMware Player Instead

VMware Player might have better kernel compatibility:
```bash
# Remove Workstation
sudo vmware-installer -u vmware-workstation

# Install Player
wget [VMware Player URL]
chmod +x VMware-Player*.bundle
sudo ./VMware-Player*.bundle
```

### Solution 2: Use VirtualBox

VirtualBox often has better kernel support:
```bash
sudo apt install virtualbox virtualbox-ext-pack
```

### Solution 3: Patch VMware Modules

Community patches are available for newer kernels:
```bash
# Check VMware community forums for patches
# Or use automated patcher tools like vmware-host-modules
```

### Solution 4: Pin Kernel Version

Prevent automatic kernel updates:
```bash
# Hold current kernel
sudo apt-mark hold linux-image-$(uname -r)
sudo apt-mark hold linux-headers-$(uname -r)

# Later, to unhold
sudo apt-mark unhold linux-image-$(uname -r)
sudo apt-mark unhold linux-headers-$(uname -r)
```

## Diagnostic Commands

Useful commands for troubleshooting:

```bash
# Check current kernel
uname -r

# List installed kernels
dpkg --list | grep linux-image

# Check VMware services
sudo systemctl status vmware

# Check loaded modules
lsmod | grep vm

# View VMware logs
cat /tmp/vmware-*.log

# Check GRUB configuration
cat /boot/grub/grub.cfg | grep menuentry

# Verify kernel headers
ls /usr/src/linux-headers-$(uname -r)

# Check gcc version
gcc --version

# Verify boot files
ls -la /boot

# Check disk partitions
sudo fdisk -l
sudo blkid
```

## Getting Help

If none of these solutions work:

1. **Check VMware Knowledge Base**
   - Search for your specific error message
   - Check compatibility lists

2. **VMware Community Forums**
   - Post your issue with system details
   - Search for similar problems

3. **GitHub Issues**
   - Create an issue in this repository
   - Include all diagnostic information

4. **Ubuntu Forums**
   - Ask in the virtualization section

## Prevention Tips

1. **Before Kernel Updates**
   - Check VMware compatibility
   - Backup important VMs
   - Test in non-production environment

2. **Regular Maintenance**
   - Keep VMware updated
   - Monitor kernel update announcements
   - Maintain working kernel backup

3. **System Configuration**
   - Document your setup
   - Keep recovery tools ready
   - Maintain Live USB for emergencies

## Additional Resources

- [VMware Compatibility Guide](https://www.vmware.com/resources/compatibility/search.php)
- [Ubuntu Kernel Documentation](https://wiki.ubuntu.com/Kernel)
- [GRUB Manual](https://www.gnu.org/software/grub/manual/)
- [VMware Community Forums](https://communities.vmware.com/)

---

**Last Updated:** February 2026
