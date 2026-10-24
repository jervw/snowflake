{lib, ...}: {
  programs.man.generateCaches = lib.mkForce false;
  home.stateVersion = lib.mkDefault "26.11";
}
