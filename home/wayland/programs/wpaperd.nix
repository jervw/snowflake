{
  self,
  pkgs,
  lib,
  ...
}: let
  version = "git";
  pname = "wpaperd-${version}";
  src = pkgs.fetchFromGitHub {
    owner = "danyspin97";
    repo = "wpaperd";
    rev = "3980d9ed99f8f61a8831da332b9dae8f513c2417";
    hash = "sha256-5/cfaeNVkJOf1X76yOIZxHE+Uk1mEVgwMMYAlBIXGYI=";
  };
in {
  programs.wpaperd = {
    enable = true;
    package = pkgs.wpaperd.overrideAttrs (oldAttrs: {
      inherit version pname src;
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-8IsMgNgFTUobTTr816VIp7hQ4RySMBTnpIjfiABHagc=";
      });
    });
    settings = {
      default = {
        path = "${self}/wallpapers";
        duration = "30m";
        group = 1;
      };
    };
  };
}
