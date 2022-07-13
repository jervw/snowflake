#!/bin/bash
set -x

# Stop display manager
systemctl stop display-manager.service

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

sleep 2

modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_2d_00_0
virsh nodedev-detach pci_0000_2d_00_1

# Load VFIO Kernel Module  
modprobe vfio-pci  

# enable cpu performace mode
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo "performance" > $file; done
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
