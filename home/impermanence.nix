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
      ++ forEach ["Yubico" "sh.cider.electron" "fish" "vesktop" "obs-studio"] (
        x: ".config/${x}"
      )
      ++ forEach ["nix" "mozilla"] (
        x: ".cache/${x}"
      )
      ++ forEach ["Steam" "fish" "direnv" "keyrings"] (x: ".local/share/${x}")
      ++ [".ssh" ".gnupg" ".mozilla"];
    files = [
      ".lock.png"
      ".wall.png"
    ];
  };
}
