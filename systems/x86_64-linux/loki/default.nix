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
        nvidia = {
          enable = true;
          enableCudaSupport = true;
        };
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
      yubikey = enabled;
    };

    services = {
      ollama = {
        enable = true;
        modelsPath = "/persist/ollama";
      };
    };

    suites = {
      core = enabled;
      desktop = enabled;
      gaming = enabled;
    };

    system = {
      backup = {
        enable = true;
        paths = [
          "/persist/etc"
          "/persist/home"
          "/persist/password"
        ];
        exclude = [
          "Steam"
          "games"
        ];
      };
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
