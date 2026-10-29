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

  boot.loader = {
    efi.efiSysMountPoint = "/boot";
  };

  nietos = {
    hardware = {
      airpods = enabled;
      cpu.intel = enabled;
      storage.ssd = true;
    };
    networking = {
      nfs = enabled;
      # Laptop roams; keep SSH Tailscale-only.
      ssh.lanSubnets = [];
      tailscale = enabled;
    };

    security = {
      hardening = enabled;
      yubikey = enabled;
    };

    suites = {
      core = enabled;
      desktop = enabled;
    };

    system = {
      backup = {
        enable = true;
        paths = [
          "/home"
          "/var/lib"
        ];
      };
      boot = {
        enable = true;
        loader = "systemd-boot";
        plymouth = true;
        silentBoot = true;
      };
    };
  };

  system.stateVersion = "24.05";
}
