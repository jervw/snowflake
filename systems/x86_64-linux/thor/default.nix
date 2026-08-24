{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  # Exceptions
  networking.firewall.interfaces.enp4s0 = {
    allowedUDPPorts = [53];
    allowedTCPPorts = [443];
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
      static-ip = {
        enable = true;
        adapter = "enp4s0";
        ip = "10.0.0.3/26";
        gateway = "10.0.0.1";
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

    services.beszel.agent.extraFilesystems = {
      "/mnt/extra" = "Extra";
      "/mnt/storage" = "Storage";
    };

    suites = {
      core = enabled;
      server = enabled;
    };

    system = {
      backup = {
        server = enabled;
        enable = true;
        paths = [
          "/home"
          "/var/lib"
        ];
      };
      boot = enabled;
    };
  };

  system.stateVersion = "24.05";
}
