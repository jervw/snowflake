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
    home.packages =
      [pkgs.${namespace}.cider-pixie]
      ++ (with pkgs; [
        xdg-utils
        anki-bin
        feishin
        ffmpeg
        tomato-c
        qbittorrent-enhanced
        # TODO: re-enable once onlyoffice-desktopeditors no longer depends on the broken gtk2
        # onlyoffice-desktopeditors
        fontpreview
        protonmail-desktop
        zennotes-desktop
        # rustdesk
        nix-search-tv
        proton-vpn-cli

        # Wayland stuff
        grimblast
        wl-clipboard
        wtype
        wlr-randr
        xclip
      ]);

    home.sessionVariables = {
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      NIXOS_OZONE_WL = 1;
    };

    nietos = {
      theme.enable = true;
      programs = {
        desktop = {
          niri = mkDefault enabled;
          noctalia = mkDefault enabled;
        };
        apps = {
          discord = mkDefault enabled;
          librewolf = mkDefault enabled;
          mpv = mkDefault enabled;
          obs = mkDefault enabled;
          imv = mkDefault enabled;
          zathura = mkDefault enabled;
        };
        term = {
          foot = mkDefault enabled;
        };
      };
    };
  };
}
