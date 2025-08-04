{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  # TODO: Make static ip configuration module
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

  snowflake = {
    hardware = {
      cpu.intel = enabled;
      storage = {
        ssd = true;
        zfs = true;
        extra = true;
      };
    };
    networking = {
      tailscale = {
        enable = true;
        extraUpFlags = [
          "--accept-dns=false"
          "--ssh"
        ];
      };
    };

    security = {
      hardening = enabled;
    };

    services = {
      comin = enabled;
      logind = enabled;
      monitoring = enabled;
    };

    suites = {
      core = enabled;
      server = enabled;
    };

    system.boot = enabled;

    virtualisation = {
      docker = enabled;
    };
  };

  system.stateVersion = "24.05";
}
