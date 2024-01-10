{
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../home/core
  ];

  programs.home-manager.enable = true;

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "23.05";
  };
}
