{...}: {
  imports = [
    ./hardware-configuration.nix
    # ./homeserver.nix
    ../../modules/core
  ];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "/dev/sda";
    };
  };

  networking.networkmanager.enable = true;
}
