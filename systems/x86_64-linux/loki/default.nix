{
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  snowflake = {
    hardware = {
      cpu.amd = enabled;
      video = {
        nvidia = enabled;
        i2c = enabled;
        lact = enabled;
      };
      storage = {
        extra = true;
        ssd = true;
      };
      qmk = enabled;
    };
    networking = {
      nfs = enabled;
      tailscale = enabled;
    };

    security = {
      hardening = enabled;
      yubikey = enabled;
    };

    services = {
      logind = enabled;
    };

    suites = {
      core = enabled;
      desktop = enabled;
      gaming = enabled;
    };

    system = {
      boot = {
        enable = true;
        plymouth = true;
        secureBoot = true;
        silentBoot = true;
      };
      impermanence = enabled;
    };

    virtualisation = {
      docker = enabled;
      qemu = enabled;
    };
  };

  system.stateVersion = "24.05";
}
