_: let
  eth = "enp4s0";
in {
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
