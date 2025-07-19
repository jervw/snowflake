{
  lib,
  namespace,
  inputs,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
    ./hardware.nix
  ];

  # Suspend is broken on T2-Macs since Sonoma
  services.logind.lidSwitch = "ignore";

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 70;
    };
  };

  boot.loader = {
    efi.efiSysMountPoint = "/boot";
  };

  snowflake = {
    hardware = {
      cpu.intel = enabled;
      storage.ssd = true;
    };
    networking = {
      nfs = enabled;
      tailscale = enabled;
    };

    programs.graphical.wm.niri = enabled;

    security = {
      hardening = enabled;
    };

    services.beszel = {
      enable = true;
      settings = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATu4vxaEbexuZV4jI5slmE0WMC2Tevux6zC0I8EPVm5";
      };
    };

    suites = {
      core = enabled;
      desktop = enabled;
    };

    system = {
      boot = {
        enable = true;
        plymouth = true;
        silentBoot = true;
      };
    };

    theme.stylix = enabled;
  };

  system.stateVersion = "24.05";
}
