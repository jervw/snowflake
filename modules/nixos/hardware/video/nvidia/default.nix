{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkDefault mkIf versionOlder;
  cfg = config.${namespace}.hardware.video.nvidia;

  # use the latest possible nvidia package
  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;

  nvidiaPackage =
    if (versionOlder nvBeta nvStable)
    then config.boot.kernelPackages.nvidiaPackages.stable
    else config.boot.kernelPackages.nvidiaPackages.beta;
in {
  options.${namespace}.hardware.video.nvidia = {
    enable = lib.mkEnableOption "support for nvidia";
    enableCudaSupport = lib.mkEnableOption "support for cuda";
  };

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = ["nouveau"];

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
        package = mkDefault nvidiaPackage;
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
        extraPackages = with pkgs; [libvdpau-va-gl nvidia-vaapi-driver];
      };
    };

    nixpkgs.config.cudaSupport = cfg.enableCudaSupport;
  };
}
