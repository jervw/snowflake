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
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_cachyos;

    # Forcing primary monitor to match the secondary resolution at KMS to avoid broken plymouth scaling.
    kernelParams = ["video=DP-1:1920x1080@60"];
  };
}
