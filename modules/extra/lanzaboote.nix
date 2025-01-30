{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  boot = {
    # Let Lanzaboote handle this
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    initrd.systemd.tpm2.enable = true;
  };

  systemd.tpm2.enable = true;

  environment.systemPackages = [pkgs.tpm2-tss];
}
