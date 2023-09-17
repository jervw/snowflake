{ pkgs, lib, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "thor";
  };

  # Services
  services = {
    openssh.enable = true;
  };
}
