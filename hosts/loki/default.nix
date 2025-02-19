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
    ../../modules/network
    ../../modules/services
    ../../modules/virtualisation

    ../../modules/hardware/nvidia.nix
    ../../modules/network/nfs.nix
    ../../modules/services/ollama.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_cachyos;
  };
}
