{lib, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/server
    ../../modules/network

    ../../modules/virtualisation/docker.nix
    ../../modules/services/comin.nix
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

  networking = let
    interface = "enp4s0";
  in {
    networkmanager.enable = lib.mkForce false;
    hostId = "7f6f07cd";
    nftables.enable = true;
    interfaces.${interface}.ipv4.addresses = [
      {
        address = "10.0.0.3";
        prefixLength = 26;
      }
    ];
    defaultGateway = {
      address = "10.0.0.1";
      inherit interface;
    };
    nameservers = ["9.9.9.9" "1.1.1.1"];
  };
}
