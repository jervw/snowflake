{lib, ...}: let
  interface = "enp4s0";
in {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/server
    ../../modules/network

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

  networking = {
    networkmanager.enable = lib.mkForce false;
    hostId = "7f6f07cd";
    nftables.enable = true;
    interfaces.${interface}.ipv4.addresses = [
      {
        address = "192.168.10.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.10.1";
      inherit interface;
    };
    nameservers = ["9.9.9.9" "1.1.1.1"];
  };
}
