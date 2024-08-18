{
  self,
  user,
  inputs,
  ...
}: let
  eth = "enp4s0";
in {
  imports = [
    inputs.agenix.nixosModules.default
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/server

    ../../modules/virtualisation/docker.nix
    ../../modules/network/tailscale.nix
    ../../modules/network/syncthing.nix
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

  age.secrets.cloudflare = {
    file = "${self}/secrets/cloudflare.age";
    owner = user;
    group = "users";
  };

  networking = {
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
    nameservers = ["127.0.0.1" "1.1.1.1"];
  };
}
