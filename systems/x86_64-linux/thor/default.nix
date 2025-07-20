{
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  # TODO: zfs module
  boot = {
    supportedFilesystems = ["zfs"];
    zfs = {
      forceImportRoot = false;
      extraPools = ["zpool"];
    };
  };

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
        extra = true;
      };
    };
    networking = {
      nfs = enabled;
      tailscale = enabled;
    };

    security = {
      hardening = enabled;
    };

    services = {
      beszel = {
        enable = true;
        settings = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATu4vxaEbexuZV4jI5slmE0WMC2Tevux6zC0I8EPVm5";
        };
      };
      comin = enabled;
      logind = enabled;
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
