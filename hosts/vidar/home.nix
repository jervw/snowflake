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
    packages = with pkgs; [
      wget
    ];

    stateVersion = "23.11";
  };
}
