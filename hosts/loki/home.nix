{
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../home/core
    ../../home/desktop
  ];

  programs.home-manager.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      xfce.thunar
      feh
      imv
      morgen
      obsidian
      vscode-fhs
      lazygit
      playerctl
      pavucontrol
      lutris
      viewnior
      qbittorrent
      discord
      networkmanagerapplet
      obs-studio
    ];

    stateVersion = "23.05";
  };
}
