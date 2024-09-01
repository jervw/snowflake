{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/a30e0cd2-299f-4608-829e-4db96aaa923e";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=25%" "mode=0755"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3de0220e-012e-490b-aaf1-d26aa151b57c";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/3de0220e-012e-490b-aaf1-d26aa151b57c";
    fsType = "btrfs";
    options = ["subvol=persist" "compress=zstd" "noatime"];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2A2E-ED11";
    fsType = "vfat";
  };

  fileSystems."/home/jervw/.steam" = {
    device = "/persist/steam/.steam";
    fsType = "none";
    options = ["bind"];
    noCheck = true;
  };

  services.fstrim.enable = true;

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
