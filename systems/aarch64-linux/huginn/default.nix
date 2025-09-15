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
      fail2ban = enabled;
      static-ip = {
        enable = true;
        adapter = "enp1s0";
        ip = "65.21.48.78/32";
        gateway = "172.31.1.1";
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
        node = enabled;
        grafana = {
          enable = true;
          scrapeTargets = {
            node = ["huginn" "loki" "thor" "fenrir"];
            zfs = ["thor"];
            cadvisor = ["thor"];
          };
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
