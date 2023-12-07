{
  inputs,
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
      gnome.nautilus
      feh
      imv
      morgen
      obsidian
      vscode-fhs
      lazygit
      playerctl
      pavucontrol
      lutris
      steam
      heroic
      (jetbrains.plugins.addPlugins jetbrains.rust-rover ["github-copilot"])
      viewnior
      qbittorrent
      discord
      networkmanagerapplet
      obs-studio
      inputs.nix-gaming.packages.${pkgs.system}.wine-ge
      (callPackage ../../pkgs/cider2 {})
    ];

    stateVersion = "23.05";
  };
}
