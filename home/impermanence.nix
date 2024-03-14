{
  lib,
  user,
  inputs,
  ...
}: let
  inherit (lib) forEach;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/nix/persist/home/${user}" = {
    allowOther = true;
    directories =
      [
        "download"
        "music"
        "dev"
        "docs"
        "pics"
        "vids"
        "other"
      ]
      ++ forEach ["Yubico" "ags" "waypaper" "Cider" "fish" "syncthing" "vesktop" "obs-studio" "Signal"] (
        x: ".config/${x}"
      )
      ++ forEach ["nix" "mozilla" "ags"] (
        x: ".cache/${x}"
      )
      ++ forEach ["Steam" "fish" "direnv" "keyrings"] (x: ".local/share/${x}")
      ++ [".ssh" ".gnupg" ".mozilla"];
    files = [
      ".lock.png"
    ];
  };
}
