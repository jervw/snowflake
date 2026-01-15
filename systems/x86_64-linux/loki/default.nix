{
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;

  snowflake = {
    hardware = {
      cpu.amd = enabled;
      video = {
        nvidia = enabled;
        i2c = enabled;
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
    };

    services = {
      ollama = {
        enable = true;
      };
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
