{
  pkgs,
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.virtualisation.qemu;
in {
  options.${namespace}.virtualisation.qemu = {
    enable = lib.mkEnableOption "QEMU virtualisation";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [virt-manager];

    networking.firewall.trustedInterfaces = [
      "virbr0"
      "br0"
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          ovmf = enabled;
          swtpm = enabled;
          runAsRoot = true;
        };
        onBoot = "ignore";
        onShutdown = "shutdown";
        extraConfig = ''
          uri_default = "qemu:///system"
        '';
      };
      spiceUSBRedirection.enable = true;
    };

    snowflake.user.extraGroups = ["kvm" "libvirtd"];
  };
}
