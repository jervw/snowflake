{
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [./hardware.nix];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;

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

    programs.graphical.wm.niri = enabled;
    # programs.graphical.wm.hyprland = enabled;

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
        secureBoot = false;
        silentBoot = true;
      };
      impermanence = enabled;
    };

    theme = {
      catppuccin = enabled;
    };

    virtualisation = {
      docker = enabled;
      qemu = enabled;
    };
  };

  system.stateVersion = "24.05";
}
