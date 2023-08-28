{config, pkgs, user, ... }:

{  
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  
  environment.systemPackages = with pkgs; [
    virt-manager
  ];
  
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemuOvmf = true;
      qemuRunAsRoot = true;
    };
  };
    
  # Add binaries to path so that hooks can use it
  systemd.services.libvirtd = {
    path = let
             env = pkgs.buildEnv {
               name = "qemu-hook-env";
               paths = with pkgs; [
                 bash
                 procps
                 libvirt
                 kmod
                 systemd
                 ripgrep
                 sd
               ];
             };
           in
             [ env ];
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];
  programs.dconf.enable = true;
  users.groups.libvirtd.members = [ "${user}" ];

  environment.etc = {
  "libvirt/hooks/qemu" = {
    text =
    ''
      #!/run/current-system/sw/bin/bash
      #
      # Author: Sebastiaan Meijer (sebastiaan@passthroughpo.st)
      #
      # Copy this file to /etc/libvirt/hooks, make sure it's called "qemu".
      # After this file is installed, restart libvirt.
      # From now on, you can easily add per-guest qemu hooks.
      # Add your hooks in /etc/libvirt/hooks/qemu.d/vm_name/hook_name/state_name.
      # For a list of available hooks, please refer to https://www.libvirt.org/hooks.html
      #

      GUEST_NAME="$1"
      HOOK_NAME="$2"
      STATE_NAME="$3"
      MISC="''${@:4}"

      BASEDIR="$(dirname $0)"

      HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

      set -e # If a script exits with an error, we should as well.

      # check if it's a non-empty executable file
      if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH"] && [ -x "$HOOKPATH" ]; then
          eval \"$HOOKPATH\" "$@"
      elif [ -d "$HOOKPATH" ]; then
          while read file; do
              # check for null string
              if [ ! -z "$file" ]; then
                eval \"$file\" "$@"
              fi
          done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
      fi
    '';
    mode = "0755";
  };

  "libvirt/hooks/kvm.conf" = {
    text =
    ''
      VIRSH_GPU_VIDEO=pci_0000_06_00_0
      VIRSH_GPU_AUDIO=pci_0000_06_00_1
    '';
    mode = "0755";
  };

  "libvirt/hooks/qemu.d/win10/prepare/begin/start.sh" = {
    text =
    ''
      #!/run/current-system/sw/bin/bash
      set -x
      pkill -f Hyprland
      sleep 3

      # Load variables we defined
      source "/etc/libvirt/hooks/kvm.conf"

      # Change to performance governor
      echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

      # Unbind VTconsoles
      echo 0 > /sys/class/vtconsole/vtcon0/bind
      echo 0 > /sys/class/vtconsole/vtcon1/bind

      # Unbind EFI Framebuffer
      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

      sleep 2

      # Unload NVIDIA kernel modules
      modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

      # Detach GPU devices from host
      virsh nodedev-detach $VIRSH_GPU_VIDEO
      virsh nodedev-detach $VIRSH_GPU_AUDIO

      sleep 2

      # Load vfio module
      modprobe vfio-pci
    '';
    mode = "0755";
  };

  "libvirt/hooks/qemu.d/win10/release/end/stop.sh" = {
    text =
    ''
      #!/run/current-system/sw/bin/bash

      # Load variables we defined
      source "/etc/libvirt/hooks/kvm.conf"

      # Unload vfio module
      modprobe -r vfio-pci

      sleep 2

      # Attach GPU devices from host
      virsh nodedev-reattach $VIRSH_GPU_VIDEO
      virsh nodedev-reattach $VIRSH_GPU_AUDIO

      # Load NVIDIA kernel modules
      modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia

      sleep 2

      # Bind EFI Framebuffer
      echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

      sleep 1

      # Bind VTconsoles
      echo 1 > /sys/class/vtconsole/vtcon0/bind
      echo 1 > /sys/class/vtconsole/vtcon1/bind

      # Change to powersave governor
      echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    '';
    mode = "0755";
  };
  };
}
