{
  pkgs,
  config,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  # This is required in kernel 6.9 to make wayland play nicely
  boot.kernelParams = [
    "nvidia-drm.fbdev=1"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    nvidia = {
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "560.28.03";
        sha256_64bit = "sha256-martv18vngYBJw1IFUCAaYr+uc65KtlHAMdLMdtQJ+Y=";
        sha256_aarch64 = "sha256-+u0ZolZcZoej4nqPGmZn5qpyynLvu2QSm9Rd3wLdDmM=";
        openSha256 = "sha256-asGpqOpU0tIO9QqceA8XRn5L27OiBFuI9RZ1NjSVwaM=";
        settingsSha256 = "sha256-b4nhUMCzZc3VANnNb0rmcEH6H7SK2D5eZIplgPV59c8=";
        persistencedSha256 = "sha256-MhITuC8tH/IPhCOUm60SrPOldOpitk78mH0rg+egkTE=";
      };
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
    };
  };

  virtualisation.docker = {
    enableNvidia = true;
  };

  environment = {
    sessionVariables = {
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      libva
      libva-utils
      glxinfo
      egl-wayland
    ];
  };
}
