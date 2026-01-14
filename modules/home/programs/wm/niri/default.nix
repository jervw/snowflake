{
  lib,
  namespace,
  ...
}: {
  options.${namespace}.programs.wm.niri = {
    enable = lib.mkEnableOption "Enable niri";
  };

  imports = lib.snowfall.fs.get-non-default-nix-files ./.;
}
