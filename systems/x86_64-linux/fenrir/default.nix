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
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  hardware.apple-t2.kernelChannel = "latest";

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

    services = {
      monitoring = {
        node = enabled;
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
  };

  system.stateVersion = "24.05";
}
