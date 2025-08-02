{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./disks.nix];

  boot.initrd.availableKernelModules = ["virtio_scsi" "sr_mod"];

  snowflake = {
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
      monitoring = {
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
