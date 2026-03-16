{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  cfg = config.${namespace}.hardware.video.nvidia;
in {
  options.${namespace}.hardware.video.nvidia = {
    enable = lib.mkEnableOption "support for nvidia";
    enableCudaSupport = lib.mkEnableOption "support for cuda";
  };

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = ["nouveau"];
    boot.kernelParams = ["nvidia.NVreg_TemporaryFilePath=/var/tmp"];

    services.xserver.videoDrivers = ["nvidia"];

    environment = {
      systemPackages = with pkgs; [
        # Mesa
        mesa

        # Vulkan
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        libva
        libva-utils
      ];
      sessionVariables = {
        # VAAPI stuff
        NVD_BACKEND = "direct";
        LIBVA_DRIVER_NAME = "nvidia";
        MOZ_DISABLE_RDD_SANDBOX = "1";

        GBM_BACKEND = "nvidia-drm";
      };
    };

    hardware = {
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        modesetting.enable = mkDefault true;

        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault false;
        };

        open = mkDefault true;
        nvidiaSettings = true;
        nvidiaPersistenced = false;
      };

      graphics = {
        enable = true;
        extraPackages = with pkgs; [nvidia-vaapi-driver];
      };
    };

    nixpkgs.config.cudaSupport = cfg.enableCudaSupport;
  };
}
