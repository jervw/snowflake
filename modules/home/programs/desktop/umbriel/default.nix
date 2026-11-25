{
  lib,
  namespace,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.${namespace}.programs.desktop.umbriel;
in {
  options.${namespace}.programs.desktop.umbriel = {
    enable = lib.mkEnableOption "Enable Umbriel";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = lib.mkIf cfg.enable {
    programs.umbriel.enable = true;

    xdg.portal = {
      # Home Manager points NIX_XDG_DESKTOP_PORTAL_DIR at the user profile, so the
      # system-wide portal installed by the NixOS module is not discovered.
      extraPortals = [
        inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-umbriel
      ];

      # ~/.config/xdg-desktop-portal/portals.conf would otherwise take precedence
      # over the packaged umbriel-portals.conf. Only used when XDG_CURRENT_DESKTOP=umbriel.
      config.umbriel = {
        default = ["umbriel" "gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["luciole" "gtk"];
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        "org.freedesktop.impl.portal.ScreenCast" = "umbriel";
        "org.freedesktop.impl.portal.Screenshot" = "umbriel";
        "org.freedesktop.impl.portal.InputCapture" = "umbriel";
        "org.freedesktop.impl.portal.GlobalShortcuts" = "umbriel";
      };
    };
  };
}
