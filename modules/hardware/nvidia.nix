{
  pkgs,
  config,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  boot = {
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm" # Can be loaded later since it's only needed for CUDA
    ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
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
