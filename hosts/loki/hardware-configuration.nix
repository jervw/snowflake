{lib, ...}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-label/nixos-luks";

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=25%" "mode=0755"];
    };

    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };

    "/persist" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/mnt/storage" = {
      device = "/dev/disk/by-label/storage";
      fsType = "ext4";
      options = ["noatime" "nofail"];
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
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
