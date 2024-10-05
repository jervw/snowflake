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
    rev = "62af4392f3e447592f768f5420821a344d190107";
    hash = "sha256-6ThcLPPfdEDtAEX91WIa6zf8piPIqRvdG68+m3JWXvM=";
  };
in {
  programs.wpaperd = {
    enable = true;
    package = pkgs.wpaperd.overrideAttrs (oldAttrs: {
      inherit version pname src;
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-pRV6WexQ5N0gmkQkDo2h7O42K8DkOch43BAd3ffBe5A=";
      });
    });
    settings = {
      any = {
        path = "${self}/wallpapers";
      };
      default.sorting.groupedrandom = {
        group = 1;
      };
    };
  };
}
