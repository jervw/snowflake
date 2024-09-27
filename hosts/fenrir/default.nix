{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-t2
    ./hardware-configuration.nix

    ../../modules/nixos/fonts.nix
    ../../modules/nixos/quiet.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/greetd.nix
    ../../modules/nixos/wayland.nix

    ../../modules/core
    ../../modules/network
    ../../modules/services
  ];

  boot.loader = {
    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
}
