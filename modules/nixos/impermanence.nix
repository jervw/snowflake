{
  inputs,
  lib,
  ...
}: let
  inherit (lib) forEach;
in {
  imports = [inputs.impermanence.nixosModule];

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories =
      [
        "/tmp"
        "/var/log"
        "/var/db/sudo"
      ]
      ++ forEach ["nixos" "NetworkManager" "nix" "ssh" "secureboot"] (x: "/etc/${x}")
      ++ forEach ["bluetooth" "nixos" "pipewire" "libvirt"] (x: "/var/lib/${x}");
    files = ["/etc/machine-id"];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /nix/persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /nix/persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /nix/persist/var/lib/NetworkManager/timestamps"
  ];
}
