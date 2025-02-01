{
  pkgs,
  config,
  ...
}: let
  # Applications
  browser = ["zen"];
  editor = ["Helix"];
  fileManager = ["yazi"];
  imageViewer = ["imv"];
  mediaPlayer = ["mpv"];
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
  browserTypes =
    (xdgAssociations "application" browser [
      "pdf"
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
    // browserTypes);
in {
  xdg = {
    mimeApps = {
      enable = true;
      inherit defaultApplications;
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
  };
  home.packages = [
    # used by `gio open` and xdp-gtk
    (pkgs.writeShellScriptBin "xdg-terminal-exec" ''
      ghostty "$@"
    '')
    pkgs.xdg-utils
  ];
}
