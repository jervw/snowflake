{lib, ...}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=root" "noatime" "compress=zstd"];
    };

    "/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=home" "noatime" "compress=zstd"];
    };

    "/mnt/storage" = {
      device = "/dev/disk/by-label/storage";
      fsType = "ext4";
      options = ["noatime" "nofail"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/efi";
      fsType = "vfat";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
  };

  services.fstrim.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
