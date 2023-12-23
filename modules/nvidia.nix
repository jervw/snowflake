{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    nvidia = {
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
    };
  };

  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      NVD_BACKEND = "direct";
      EGL_PLATFORM = "wayland";
    };
    systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      xclip
      xorg.xeyes
      libva
      libva-utils
      glxinfo
      egl-wayland
    ];
  };

  # Ugly hack to fix a bug in egl-wayland, see
  # https://github.com/NixOS/nixpkgs/issues/202454
  environment.etc."egl/egl_external_platform.d".source = let
    nvidia_wayland = pkgs.writeText "10_nvidia_wayland.json" ''
      {
          "file_format_version" : "1.0.0",
          "ICD" : {
              "library_path" : "${pkgs.egl-wayland}/lib/libnvidia-egl-wayland.so"
          }
      }
    '';
    nvidia_gbm = pkgs.writeText "15_nvidia_gbm.json" ''
      {
          "file_format_version" : "1.0.0",
          "ICD" : {
              "library_path" : "${config.hardware.nvidia.package}/lib/libnvidia-egl-gbm.so.1"
          }
      }
    '';
  in
    lib.mkForce (pkgs.runCommandLocal "nvidia-egl-hack" {} ''
      mkdir -p $out
      cp ${nvidia_wayland} $out/10_nvidia_wayland.json
      cp ${nvidia_gbm} $out/15_nvidia_gbm.json
    '');

  services.xserver.videoDrivers = ["nvidia"];
}
