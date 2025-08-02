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
      storage = {
        extra = true;
        ssd = true;
      };
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
        enable = true;
        modelsPath = "/mnt/storage/ollama-models";
      };

      beszel = {
        enable = true;
        settings = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATu4vxaEbexuZV4jI5slmE0WMC2Tevux6zC0I8EPVm5";
        };
      };

      monitoring = enabled;

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
