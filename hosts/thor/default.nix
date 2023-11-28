{...}: {
  imports = [
    ./hardware-configuration.nix
    ./services
    ../../modules/core
    ../../modules/virtualisation
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["zfs"];
    zfs = {
      forceImportRoot = false;
      extraPools = ["zpool"];
    };
  };

  networking = {
    hostName = "thor";
    hostId = "7f6f07cd";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
}
