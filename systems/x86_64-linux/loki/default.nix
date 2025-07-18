{
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  snowflake = {
    hardware = {
      cpu.amd = enabled;
      nvidia = enabled;
      qmk = enabled;
      ssd = enabled;
    };
    networking = {
      nfs = enabled;
      tailscale = enabled;
    };

    programs.graphical.wm.hyprland = enabled;

    security = {
      hardening = enabled;
    };

    services = {
      ollama = {
        enabled = true;
        modelsPath = "/mnt/storage/ollama-models";
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
      impermamence = enabled;
    };

    theme.stylix = enabled;

    virtualisation = {
      docker = enabled;
      qemu = enabled;
    };
  };

  system.stateVersion = "24.05";
}
