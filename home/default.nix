{user, ...}: {
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "24.05";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  programs.home-manager.enable = true;

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}
