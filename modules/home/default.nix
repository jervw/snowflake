{
  lib,
  osConfig ? {},
  ...
}: {
  home.stateVersion = lib.mkDefault (osConfig.system.stateVersion or "24.05");
}
