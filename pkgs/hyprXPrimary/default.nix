{pkgs, ...}: {
  hy3 = pkgs.callPackage ({
    lib,
    fetchFromGitHub,
    cmake,
    hyprland,
    hyprlandPlugins,
  }:
    hyprlandPlugins.mkHyprlandPlugin pkgs.hyprland {
      pluginName = "hyprXPrimary";
      version = "0.41.2";

      src = fetchFromGitHub {
        owner = "zakk4223";
        repo = "hyprXPrimary";
        rev = "7b781613900cac7ebc3058ff5b4b43d6cded07a6";
        hash = "";
      };

      # any nativeBuildInputs required for the plugin
      nativeBuildInputs = [cmake];

      # set any buildInputs that are not already included in Hyprland
      # by default, Hyprland and its dependencies are included
      buildInputs = [];

      meta = {
        homepage = "https://github.com/zakk4223/hyprXPrimary";
        description = "Set a primary X11 display for hyprland";
        license = lib.licenses.bsd3;
        platforms = lib.platforms.linux;
        maintainers = with lib.maintainers; [jervw];
      };
    });
}
