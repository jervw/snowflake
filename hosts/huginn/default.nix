{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/core
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
  };
}
