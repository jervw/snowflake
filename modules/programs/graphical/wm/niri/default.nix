{
  config,
  lib,
  pkgs,
  namespace,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.${namespace}.programs.graphical.wm.niri;
in {
  imports = [inputs.niri.nixosModules.niri];

  options.${namespace}.programs.graphical.wm.niri = {
    enable = lib.mkEnableOption "Enable Niri";
  };

  config = {
    programs.niri = {
      inherit (cfg) enable;
      package = pkgs.niri;
    };

    ${namespace}.programs.graphical.display-managers.greetd.sessions = mkIf cfg.enable [
      "niri-session &> /dev/null"
    ];
  };
}
