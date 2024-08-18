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
  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/34df0c89-c590-4d2e-9ddf-76f98ca17dd5";

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=8G" "mode=755"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/43c25427-ccf6-4382-8bb4-c247f817e7ed";
    fsType = "ext4";
    neededForBoot = true;
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6694-9D4D";
    fsType = "vfat";
  };

  services.fstrim.enable = true;

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
