{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./disks.nix];

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" "sr_mod"];

  snowflake = {
    networking = {
      # tailscale = enabled;
    };

    security = {
      hardening = enabled;
    };

    services = {
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
