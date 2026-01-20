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
      anki-bin
      calibre
      beeper
      ffmpeg
      playerctl
      tomato-c
      qbittorrent-enhanced
      fontpreview
      cider-2
      vesktop
      logseq
    ];

    snowflake = {
      theme.enable = true;
      programs = {
        addons = {
          trayscale = mkDefault enabled;
        };
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
        editors = {
          zed = mkDefault enabled;
        };
        term = {
          ghostty = mkDefault enabled;
        };
      };
    };
  };
}
