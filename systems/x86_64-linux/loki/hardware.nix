{lib, ...}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "xfs";
      options = [ "noatime" "nodiratime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
