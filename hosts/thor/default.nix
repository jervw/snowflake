{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/virtualisation
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "loki";
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };
}
