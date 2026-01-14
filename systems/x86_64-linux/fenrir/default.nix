{
  lib,
  namespace,
  ...
}: let
  inherit (lib.${namespace}) enabled;
in {
  imports = [
    ./hardware.nix
  ];

  # Suspend is broken on T2-Macs since Sonoma
  services.logind.settings.Login.HandleLidSwitch = "ignore";

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

    programs.wm.niri = enabled;

    security = {
      hardening = enabled;
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
  };

  system.stateVersion = "24.05";
}
