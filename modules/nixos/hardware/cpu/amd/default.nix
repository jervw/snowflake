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
    boot = {
      blacklistedKernelModules = ["k10temp"];
      # extraModulePackages = [config.boot.kernelPackages.zenpower];
      kernelModules = [
        "kvm-amd"
        # "zenpower"
      ];

      kernelParams = ["amd_pstate=active"];
    };

    environment.systemPackages = [pkgs.amdctl];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
