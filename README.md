# Troubleshooting Guide: Linux Kernel & VMware Module Fix

This repository provides solutions for fixing VMware Workstation module compilation issues (vmmon and vmnet) on Ubuntu systems running incompatible kernel versions.

## 🔴 Problem Description

After a system update, newer Linux kernel versions (e.g., 6.17.0-14-generic) may become incompatible with VMware Workstation, causing:

**Error 1:** VMware cannot compile kernel modules (`vmmon` and `vmnet`)
**Error 2:** System fails to boot, stuck at `GRUB Minimal BASH-like` prompt

## ✅ Solution Overview

This guide provides two phases:
- **Phase A:** Recovering the bootloader (if system won't boot)
- **Phase B:** Setting a stable kernel as default

## 📋 Prerequisites

- Ubuntu Linux system
- VMware Workstation installed
- Root/sudo access
- Affected by kernel 6.17+ incompatibility

## 🚀 Quick Fix (Automated)

Use the automated script to fix VMware module issues:

```bash
# Download and run the fix script
curl -O https://raw.githubusercontent.com/mrsonic9/Troubleshooting-Guide-Linux-Kernel-VMware-Module-Fix/main/fix-vmware-modules.sh
chmod +x fix-vmware-modules.sh
sudo ./fix-vmware-modules.sh
```

## 🔧 Manual Fix Instructions

### Phase A: Recovering the Bootloader

If your system is stuck at the GRUB prompt and won't boot:

1. **Access GRUB Menu**
   - Restart your system
   - Press `Shift + Esc` during boot to access the GRUB menu

2. **Identify Your Boot Partition**
   ```bash
   ls  # List all disks
   ls (hd0,gpt5)/  # Check each partition for Ubuntu files
   ```

3. **Set Boot Parameters**
   
   Once you find your Ubuntu partition (e.g., `hd0,gpt5`), run:
   ```bash
   set prefix=(hd0,gpt5)/boot/grub
   set root=(hd0,gpt5)
   insmod normal
   normal
   ```
   
   ⚠️ **Note:** Replace `(hd0,gpt5)` with your actual partition identifier

4. **Boot into Ubuntu**
   
   After running these commands, GRUB should display the boot menu. Select Ubuntu to boot.

### Phase B: Stabilizing the Kernel

To prevent the error from returning, set a stable kernel (like 6.8.0-100-generic) as default:

1. **Install Grub Customizer**
   ```bash
   sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
   sudo apt update
   sudo apt install grub-customizer -y
   ```

2. **Configure Default Kernel**
   ```bash
   sudo grub-customizer
   ```
   
   In Grub Customizer:
   - Locate "Ubuntu, with Linux 6.8.0-100-generic" in the list
   - Select it
   - Click the up arrow to move it to the top
   - Save and close

3. **Reboot System**
   ```bash
   sudo reboot
   ```

4. **Verify Kernel Version**
   ```bash
   uname -r
   ```
   
   You should see: `6.8.0-100-generic`

5. **Start VMware**
   
   VMware should now work smoothly without module compilation errors.

## 🔍 Troubleshooting

### Check Current Kernel
```bash
uname -r
```

### List All Installed Kernels
```bash
dpkg --list | grep linux-image
```

### Check VMware Module Status
```bash
sudo systemctl status vmware
lsmod | grep vm
```

### Manually Compile VMware Modules
```bash
sudo vmware-modconfig --console --install-all
```

### Remove Problematic Kernel
If you want to remove the incompatible kernel:
```bash
sudo apt remove linux-image-6.17.0-14-generic
sudo apt autoremove
sudo update-grub
```

## 📚 Additional Resources

- [VMware Knowledge Base](https://kb.vmware.com/)
- [Ubuntu Kernel Updates](https://wiki.ubuntu.com/Kernel)
- [GRUB Documentation](https://www.gnu.org/software/grub/manual/)

## 🤝 Contributing

If you have improvements or additional solutions, please:
1. Fork this repository
2. Create a feature branch
3. Submit a pull request

## 📝 Notes

- Always backup important data before kernel modifications
- The stable kernel version (6.8.0-100-generic) may vary based on your Ubuntu version
- Some VMware versions may require specific kernel versions for compatibility

## 💬 Support

If you face any problems, please:
1. Check the troubleshooting section above
2. Create an issue in this repository
3. Provide your kernel version and VMware version

## ⚖️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Good Luck!** 🎉
