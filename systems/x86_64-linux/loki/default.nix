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

  # Set correct resolution to TTY. Maybe NVIDIA BUG?
  # Downside of this workaround is that now the secondary monitor is at wrong resolution.
  systemd.services.fix-tty-resolution = {
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.fbset}/bin/fbset -xres 2560 -yres 1440";
      RemainAfterExit = true;
    };
  };

  snowflake = {
    programs = {
      apps.flatpak = enabled;
      addons.chromium-policies = enabled;
    };
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
