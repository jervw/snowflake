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
    # Plymouth runs in the initrd. Without the driver there it draws on the
    # firmware framebuffer, which mirrors every output at the lowest resolution.
    boot.initrd.kernelModules = mkIf config.boot.plymouth.enable ["nvidia" "nvidia_modeset" "nvidia_drm"];

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
        powerManagement.enable = mkDefault true;
        open = mkDefault true;
      };

      graphics = {
        extraPackages = with pkgs; [nvidia-vaapi-driver];
      };
    };

    nixpkgs.config.cudaSupport = cfg.enableCudaSupport;
  };
}
