{
  config,
  lib,
  pkgs,
  inputs,
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
      xdg-utils
      anki-bin
      cider-2
      beeper
      feishin
      ffmpeg
      tomato-c
      qbittorrent-enhanced
      fontpreview
      protonmail-desktop

      (inputs.helix-notes.packages.${pkgs.stdenv.hostPlatform.system}.default)

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
          brave = mkDefault enabled;
          discord = mkDefault enabled;
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
