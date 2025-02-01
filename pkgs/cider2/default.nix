{
  callPackage,
  fetchurl,
  lib,
  stdenv,
}: let
  pname = "Cider";
  version = "02-01-2025";

  # Packages are not public domain.
  # Buy Cider from https://cidercollective.itch.io/cider
  sources = {
    x86_64-linux = {
      url = "https://r2.jervw.dev/${pname}-Linux-${version}.AppImage";
      hash = "sha256-Jkn5DQob0RCsBnOtsU8RqAg0w/zn8BqOdv2XoGxCCkg=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system}) url hash;
  };

  meta = {
    mainProgram = "cider";
    description = "Cross-platform Apple Music client";
    homepage = "https://cider.sh/";
    license = lib.licenses.mit; # This is actually unfree package, but to make the flake.nix little prettier idc enough.
    maintainers = with lib.maintainers; [jervw];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
in
  callPackage ./linux.nix {inherit pname version src meta;}
