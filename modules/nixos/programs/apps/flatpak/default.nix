{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.apps.flatpak;
in {
  options.${namespace}.programs.apps.flatpak = {
    enable = lib.mkEnableOption "Enable Flatpak";
  };
  config = mkIf cfg.enable {
    # Inlined from services.flatpak to avoid forcing xdg.portal.enable on NixOS side.
    environment.systemPackages = [pkgs.flatpak pkgs.fuse3];
    security.polkit.enable = true;
    fonts.fontDir.enable = true;
    services.dbus.packages = [pkgs.flatpak];
    systemd.packages = [pkgs.flatpak];
    systemd.tmpfiles.packages = [pkgs.flatpak];
    environment.profiles = [
      "$HOME/.local/share/flatpak/exports"
      "/var/lib/flatpak/exports"
    ];
    users.users.flatpak = {
      description = "Flatpak system helper";
      group = "flatpak";
      isSystemUser = true;
    };
    users.groups.flatpak = {};
  };
}
