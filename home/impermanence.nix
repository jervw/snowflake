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
        "sync"
        "other"
        "games"
        ".dots"
      ]
      ++ forEach ["dconf" "rclone" "Yubico" "sh.cider.electron" "syncthing" "fish" "vesktop" "obs-studio" "gh" "zed"] (
        x: ".config/${x}"
      )
      ++ forEach ["nix" "mozilla" "lutris"] (
        x: ".cache/${x}"
      )
      ++ forEach ["Steam" "fish" "direnv" "keyrings" "chatterino" "gh" "lutris"] (x: ".local/share/${x}")
      ++ [".ssh" ".gnupg" ".mozilla"];
  };
}
