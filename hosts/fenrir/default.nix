{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
    ./hardware-configuration.nix

    ../../modules/extra/stylix.nix
    ../../modules/extra/quiet.nix
    ../../modules/extra/sddm.nix
    ../../modules/extra/wayland.nix

    ../../modules/core
    ../../modules/network
    ../../modules/services
  ];

  # Suspend is broken on T2-Macs since Sonoma
  services.logind.lidSwitch = "ignore";

  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
}
