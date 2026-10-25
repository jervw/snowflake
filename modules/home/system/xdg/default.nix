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
  browser = ["librewolf"];
  editor = ["Helix"];
  fileManager = ["thunar"];
  imageViewer = ["imv"];
  mediaPlayer = ["mpv"];
  docView = ["org.pwmt.zathura-pdf-mupdf"];
  officeSuite = ["onlyoffice-desktopeditors"];
  torrentClient = ["org.qbittorrent.qBittorrent"];
  archiveManager = ["org.gnome.FileRoller"];

  # Stolen from @fufexan
  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  image = xdgAssociations "image" imageViewer [
    "png"
    "apng"
    "jpeg"
    "gif"
    "webp"
    "avif"
    "bmp"
    "tiff"
    "svg+xml"
  ];
  video = xdgAssociations "video" mediaPlayer [
    "mp4"
    "vnd.avi"
    "x-msvideo"
    "matroska"
    "x-matroska"
    "webm"
    "quicktime"
    "ogg"
    "mpeg"
    "x-flv"
  ];
  audio = xdgAssociations "audio" mediaPlayer [
    "mpeg"
    "mp4"
    "flac"
    "vnd.wave"
    "x-wav"
    "aac"
    "ogg"
    "x-opus+ogg"
    "x-vorbis+ogg"
  ];
  document = xdgAssociations "application" docView [
    "pdf"
    "epub+zip"
  ];
  office = xdgAssociations "application" officeSuite [
    "msword"
    "vnd.ms-excel"
    "vnd.ms-powerpoint"
    "vnd.openxmlformats-officedocument.wordprocessingml.document"
    "vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    "vnd.openxmlformats-officedocument.presentationml.presentation"
    "vnd.oasis.opendocument.text"
    "vnd.oasis.opendocument.spreadsheet"
    "vnd.oasis.opendocument.presentation"
  ];
  text =
    (xdgAssociations "text" editor [
      "plain"
      "markdown"
      "csv"
      "x-log"
      "x-nix"
      "x-python"
      "x-shellscript"
    ])
    // (xdgAssociations "application" editor [
      "json"
      "toml"
      "yaml"
      "x-shellscript"
    ]);
  archive = xdgAssociations "application" archiveManager [
    "zip"
    "x-tar"
    "x-compressed-tar"
    "x-bzip2-compressed-tar"
    "x-xz-compressed-tar"
    "x-zstd-compressed-tar"
    "gzip"
    "x-bzip"
    "x-bzip2"
    "x-xz"
    "zstd"
    "x-7z-compressed"
    "vnd.rar"
    "x-rar"
  ];
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
      "inode/directory" = fileManager;
      "x-scheme-handler/magnet" = torrentClient;
    }
    // image
    // video
    // audio
    // document
    // office
    // text
    // archive
    // browserTypes);
in {
  options.${namespace}.system.xdg = {
    enable = mkEnableOption "xdg";
  };

  config = mkIf cfg.enable {
    home.preferXdgDirectories = true;

    xdg = {
      enable = true;

      mimeApps = {
        enable = true;
        inherit defaultApplications;
      };

      userDirs = {
        enable = true;
        setSessionVariables = true;
        documents = "$HOME/other";
        download = "$HOME/download";
        videos = "$HOME/vids";
        music = "$HOME/music";
        pictures = "$HOME/pics";
        desktop = "$HOME/docs";
        publicShare = "$HOME/other";
        templates = "$HOME/other";
        extraConfig = {
          SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
        };
      };

      portal = {
        enable = true;
        xdgOpenUsePortal = true;

        config = {
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

        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
          gnome-keyring
        ];
      };
    };
  };
}
