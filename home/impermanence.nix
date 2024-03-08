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

  home.persistence."/persist/home/${user}" = {
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
      ++ forEach ["fish" "syncthing" "VencordDesktop" "obs-studio" "Signal"] (
        x: ".config/${x}"
      )
      ++ forEach ["nix" "mozilla"] (
        x: ".cache/${x}"
      )
      ++ forEach ["fish" "direnv" "keyrings"] (x: ".local/share/${x}")
      ++ [".ssh" ".mozilla"];
    files = [
      ".lock.png"
    ];
  };
}
