# Quick Start Guide

## 🚨 Emergency: System Won't Boot?

If your system is stuck at GRUB prompt:
```bash
# Run this helper script from a working system or Live USB
./grub-recovery-helper.sh
```

OR follow these commands at GRUB prompt:
```bash
ls                               # Find your partition
set prefix=(hd0,gpt5)/boot/grub # Replace with your partition
set root=(hd0,gpt5)
insmod normal
normal
```

## 🔧 Quick Fix: VMware Module Issues

If you can boot but VMware doesn't work:

### Option 1: Automated (Recommended)
```bash
sudo ./fix-vmware-modules.sh
```

### Option 2: Manual
1. Install Grub Customizer:
   ```bash
   sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
   sudo apt update && sudo apt install grub-customizer -y
   ```

2. Set stable kernel as default:
   ```bash
   sudo grub-customizer
   ```
   - Find "Ubuntu, with Linux 6.8.0-100-generic"
   - Move it to the top
   - Save and reboot

## 📚 Need More Help?

- **Detailed Instructions**: See [README.md](README.md)
- **Advanced Troubleshooting**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)

## 🎯 What This Fixes

- ✅ VMware vmmon module compilation errors
- ✅ VMware vmnet module compilation errors
- ✅ GRUB boot failures after kernel updates
- ✅ Kernel incompatibility with VMware Workstation

## ⚡ Commands Reference

```bash
# Check current kernel
uname -r

# List installed kernels
dpkg --list | grep linux-image

# Check VMware status
sudo systemctl status vmware

# Verify modules are loaded
lsmod | grep vm
```

## 💡 Tips

1. **Before Updates**: Check VMware compatibility
2. **Keep Working Kernel**: Don't remove 6.8.x kernels
3. **Backup VMs**: Before any system changes
4. **Test First**: In non-production environment

---

For complete documentation, start with [README.md](README.md).
