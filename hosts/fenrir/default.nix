{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
    ./hardware-configuration.nix

    ../../modules/extra/stylix.nix
    ../../modules/extra/quiet.nix
    ../../modules/extra/wayland.nix
    ../../modules/extra/greetd.nix

    ../../modules/core
    ../../modules/network
    ../../modules/services

    ../../modules/hardware/bluetooth.nix
    ../../modules/network/nfs.nix
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
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
}
