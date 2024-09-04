{
  lib,
  pkgs,
  ...
}: let
  eth = "enp4s0";
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/server
    ../../modules/network

    ../../modules/hardware/nvidia.nix
    ../../modules/virtualisation/docker.nix
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

  environment.defaultPackages = with pkgs; [borgbackup];

  # Do not use open source kernel modules as it has no support for GTX970
  hardware.nvidia.open = lib.mkForce false;

  networking = {
    networkmanager.enable = lib.mkForce false;
    hostId = "7f6f07cd";
    nftables.enable = true;
    interfaces.${eth}.ipv4.addresses = [
      {
        address = "10.0.0.2";
        prefixLength = 28;
      }
    ];
    defaultGateway = {
      address = "10.0.0.1";
      interface = eth;
    };
    nameservers = ["9.9.9.9" "1.1.1.1"];
  };
}
