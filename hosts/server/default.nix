{ pkgs, lib, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../../modules/containers) ];

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
