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
    ../../modules/virtualisation

    ../../modules/network/tailscale.nix
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
    firewall.enable = false; # TODO enable later

    interfaces.${eth}.ipv4.addresses = [
      {
        address = "192.168.50.140";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.50.1";
      interface = eth;
    };
    nameservers = ["127.0.0.1" "1.1.1.1"];
  };
}
