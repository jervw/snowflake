{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.hardware.cpu.amd;
in {
  options.${namespace}.hardware.cpu.amd = {
    enable = lib.mkEnableOption "support for AMD cpu";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = ["amd_pstate=active"];

    environment.systemPackages = [pkgs.amdctl];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
