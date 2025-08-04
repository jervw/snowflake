{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

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
      static-ip = {
        enable = true;
        adapter = "enp4s0";
        addresses = ["10.0.0.3/26"];
        gateways = ["10.0.0.1"];
        dns = ["9.9.9.9" "1.1.1.1"];
      };
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
