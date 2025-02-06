{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.chaotic.nixosModules.default
    ./hardware-configuration.nix

    ../../modules/core
    ../../modules/extra
    ../../modules/hardware
    ../../modules/network
    ../../modules/services
    ../../modules/virtualisation

    ../../modules/network/nfs.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_cachyos;
  };
}
