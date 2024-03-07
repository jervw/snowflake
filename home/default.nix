{user, ...}: {
  imports = [
    ./core
    ./desktop
    ./wayland
    ./impermanence.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  programs.home-manager.enable = true;

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}
