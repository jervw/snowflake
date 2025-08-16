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
      nautilus
      ffmpeg
      obsidian
      normcap
      playerctl
      tomato-c
      qbittorrent-enhanced
      fontpreview
      pkgs.${namespace}.cider
    ];

    snowflake = {
      programs = {
        graphical = {
          addons = {
            trayscale = mkDefault enabled;
            vesktop-fix = mkDefault enabled;
          };
          browsers = {
            zen = mkDefault enabled;
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
          terminal = {
            foot = mkDefault enabled;
          };
        };
      };
    };
  };
}
