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
      steam
      heroic
      qbittorrent
      vesktop
      obs-studio
      vial
      (jetbrains.plugins.addPlugins jetbrains.rust-rover ["github-copilot"])
      (callPackage ../../pkgs/cider2 {})
    ];

    stateVersion = "23.05";
  };
}
