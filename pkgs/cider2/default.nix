{
  callPackage,
  fetchurl,
  lib,
  stdenv,
}: let
  pname = "cider";
  version = "2.3.0";

  # Packages are not public domain.
  # Buy Cider2 from https://cidercollective.itch.io/cider
  sources = {
    x86_64-darwin = {
      url = "https://r2.jervw.dev/Cider2-x64.dmg";
      hash = "sha256-5yQY/3QIc26vBSl5+NhhVxKiuLaiQb5YHoVdyqx57H0=";
    };

    x86_64-linux = {
      url = "https://r2.jervw.dev/Cider-${version}.AppImage";
      hash = "sha256-7CkMCJlbi5mSlsjP5FOj9Prn6zKblz6yrbLDmPec1uI=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system}) url hash;
  };

  meta = {
    mainProgram = "cider";
    description = "Cross-platform Apple Music client";
    homepage = "https://cider.sh/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [jervw];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
  };
in
  if stdenv.isDarwin
  then callPackage ./darwin.nix {inherit pname version src meta;}
  else callPackage ./linux.nix {inherit pname version src meta;}
