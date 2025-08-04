{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./disks.nix];

  boot.initrd.availableKernelModules = ["virtio_scsi" "sr_mod"];

  services.openssh.openFirewall = lib.mkForce false;

  snowflake = {
    networking = {
      static-ip = {
        enable = true;
        adapter = "enp1s0";
        addresses = ["65.21.48.78/32" "fe80::766:7df2:3262:5f8c/64"];
        gateways = ["172.31.1.1 " "fe80::1"];
        dns = ["1.1.1.1" "1.0.0.1"];
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
      caddy = enabled;
      monitoring = {
        enable = true;
        grafana = {
          enable = true;
          scrapeTargets = [
            "huginn:9100"
            "loki:9100"
            "thor:9100"
            "fenrir:9100"
          ];
        };
      };
    };

    suites = {
      core = enabled;
    };

    system.boot = enabled;
  };

  system.stateVersion = "24.05";
}
