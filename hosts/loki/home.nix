{
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../home/core
    ../../home/desktop
    ../../home/wayland
  ];

  programs.home-manager.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      gnome.file-roller
      gnome.nautilus
      loupe
      networkmanagerapplet
      feh
      vscode-fhs
      playerctl
      pavucontrol
      lutris
      heroic
      qbittorrent
      vesktop
      steam
      streamlink
      chatterino2
      obs-studio
      vial
      (callPackage ../../pkgs/cider2 {})
    ];

    stateVersion = "23.11";
  };
}
