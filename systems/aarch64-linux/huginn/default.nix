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
      tailscale = enabled;
    };

    security = {
      hardening = enabled;
    };

    services = {
      comin = enabled;
    };

    suites = {
      core = enabled;
    };

    system.boot = enabled;

    virtualisation = {
      docker = enabled;
    };
  };

  system.stateVersion = "24.05";
}
