{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.system.xdg;

  # Applications
  browser = ["zen-twilight"];
  editor = ["Helix"];
  fileManager = ["thunar"];
  imageViewer = ["imv"];
  mediaPlayer = ["mpv"];
  docView = ["zathura"];
  torrentClient = ["org.qbittorrent.qBittorrent"];

  # Stolen from @fufexan
  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  image = xdgAssociations "image" imageViewer ["png" "svg" "jpeg" "gif" ".svg"];
  video = xdgAssociations "video" mediaPlayer ["mp4" "avi" "mkv" "webm" "mov"];
  audio = xdgAssociations "audio" mediaPlayer ["mp3" "flac" "wav" "aac"];
  document = xdgAssociations "documents" docView ["pdf"];
  browserTypes =
    (xdgAssociations "application" browser [
      "x-extension-htm"
      "x-extension-html"
      "x-extension-shtml"
      "x-extension-xht"
      "x-extension-xhtml"
      "xhtml+xml"
    ])
    // (xdgAssociations "x-scheme-handler" browser [
      "about"
      "chrome"
      "ftp"
      "http"
      "https"
      "unknown"
    ]);

  defaultApplications = builtins.mapAttrs (_: v: (map (e: "${e}.desktop") v)) ({
      "text/html" = browser;
      "text/plain" = editor;
      "inode/directory" = fileManager;
      "x-scheme-handler/magnet" = torrentClient;
    }
    // image
    // video
    // audio
    // document
    // browserTypes);
in {
  # NOTE: Can test with `, ashpd-demo`
  options.${namespace}.system.xdg = {
    enable = mkEnableOption "xdg";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.gcr];

    home.preferXdgDirectories = true;

    xdg = {
      enable = true;

      mimeApps = {
        enable = true;
        inherit defaultApplications;
      };

      terminal-exec = {
        enable = true;
        settings = {
          default = ["foot.desktop"];
        };
      };

      userDirs = {
        enable = true;
        documents = "$HOME/other";
        download = "$HOME/download";
        videos = "$HOME/vids";
        music = "$HOME/music";
        pictures = "$HOME/pics";
        desktop = "$HOME/other";
        publicShare = "$HOME/other";
        templates = "$HOME/other";
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        };
      };

      portal = {
        enable = true;
        xdgOpenUsePortal = true;

        config = {
          hyprland = mkIf config.${namespace}.programs.wm.hyprland.enable {
            default = [
              "hyprland"
              "gtk"
              "gnome"
            ];
            "org.freedesktop.impl.portal.Screencast" = "hyprland";
            "org.freedesktop.impl.portal.Screenshot" = "hyprland";
          };
          common = {
            default = [
              "gtk"
              "gnome"
            ];

            # GTK
            "org.freedesktop.impl.portal.Access" = "gtk";
            "org.freedesktop.impl.portal.Account" = "gtk";
            "org.freedesktop.impl.portal.AppChooser" = "gtk";
            "org.freedesktop.impl.portal.Device" = "gtk";
            "org.freedesktop.impl.portal.DynamicLauncher" = "gtk";
            "org.freedesktop.impl.portal.Email" = "gtk";
            "org.freedesktop.impl.portal.FileChooser" = "gtk";
            "org.freedesktop.impl.portal.Lockdown" = "gtk";
            "org.freedesktop.impl.portal.Notification" = "gtk";
            "org.freedesktop.impl.portal.Print" = "gtk";
            "org.freedesktop.impl.portal.Screencast" = "gtk";
            "org.freedesktop.impl.portal.Screenshot" = "gtk";

            # Gnome
            "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
            "org.freedesktop.impl.portal.Background" = "gnome";
            "org.freedesktop.impl.portal.Clipboard" = "gnome";
            "org.freedesktop.impl.portal.InputCapture" = "gnome";
            "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
          };
        };

        extraPortals = with pkgs;
          [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
            gnome-keyring
          ]
          ++ lib.optional config.wayland.windowManager.hyprland.enable xdg-desktop-portal-hyprland;
      };
    };
  };
}
