{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    # Let Lanzaboote handle this
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
