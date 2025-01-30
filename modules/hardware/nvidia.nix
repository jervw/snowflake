{
  pkgs,
  config,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  boot = {
    kernelParams = [
      "nvidia-drm.fbdev=1"
    ];
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];
    kernelModules = [
      "nvidia_uvm" # Can be loaded later since it's only needed for CUDA
    ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "570.86.16"; # use new 570 drivers
        sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
        openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
        settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
        usePersistenced = false;
      };
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    nvidia-container-toolkit = {
      enable = true;
    };
  };

  environment = {
    sessionVariables = {
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      vulkan-loader
      vdpauinfo
      vulkan-tools
      libva
      libva-utils
      glxinfo
      egl-wayland
      libglvnd
      libGL
    ];
  };
}
