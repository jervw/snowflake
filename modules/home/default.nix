{
  lib,
  osConfig ? {},
  ...
}: {
  programs.man.generateCaches = lib.mkForce false;
  home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "24.05");
}
