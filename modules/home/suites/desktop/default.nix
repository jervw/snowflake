{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.suites.desktop;
in {
  options.${namespace}.suites.desktop = {
    enable = lib.mkEnableOption "desktop applications";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      xdg-utils
      anki-bin
      cider-2
      # calibre
      beeper
      ffmpeg
      tomato-c
      qbittorrent-enhanced
      fontpreview
      equibop

      # Wayland stuff
      grimblast
      wl-clipboard
      wtype
      wlr-randr
      xclip
    ];

    home.sessionVariables = {
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      NIXOS_OZONE_WL = 1;
    };

    snowflake = {
      theme.enable = true;
      programs = {
        desktop = {
          niri = mkDefault enabled;
          noctalia = mkDefault enabled;
        };
        apps = {
          mpv = mkDefault enabled;
          obs = mkDefault enabled;
          imv = mkDefault enabled;
          zathura = mkDefault enabled;
        };
        term = {
          ghostty = mkDefault enabled;
        };
      };
    };
  };
}
