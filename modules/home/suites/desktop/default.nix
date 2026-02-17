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
      xdg-utils
      anki-bin
      calibre
      beeper
      ffmpeg
      tomato-c
      qbittorrent-enhanced
      fontpreview
      tana
      equibop
      fractal
      logseq
    ];

    snowflake = {
      theme.enable = true;
      programs = {
        browsers = {
          brave = mkDefault enabled;
        };
        apps = {
          freetube = mkDefault enabled;
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
