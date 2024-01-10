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
      gnome.file-roller
      gnome.nautilus
      feh
      imv
      vscode-fhs
      lazygit
      playerctl
      pavucontrol
      lutris
      steam
      heroic
      viewnior
      qbittorrent
      vesktop
      obs-studio
      (jetbrains.plugins.addPlugins jetbrains.rust-rover ["github-copilot"])
      (callPackage ../../pkgs/cider2 {})
    ];

    stateVersion = "23.05";
  };
}
