{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.services.beszel;
in {
  options.${namespace}.services.beszel = {
    enable = mkEnableOption "Enable beszel-agent service";
  };

  config = mkIf cfg.enable {
    services.beszel = {
      enable = true;
      settings = {
        openFirewall = true;
        # TODO: Somehow define this globally
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATu4vxaEbexuZV4jI5slmE0WMC2Tevux6zC0I8EPVm5";
      };
    };
  };
}
