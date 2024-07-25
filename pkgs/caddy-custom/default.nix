{
  pkgs,
  plugins,
  ...
}:
with pkgs;
  stdenv.mkDerivation rec {
    pname = "caddy";
    version = "2.7.6";
    dontUnpack = true;

    nativeBuildInputs = [git go xcaddy];

    configurePhase = ''
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH="$TMPDIR/go"
    '';

    buildPhase = let
      pluginArgs = lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in ''
      runHook preBuild
      ${xcaddy}/bin/xcaddy build "v${version}" ${pluginArgs}
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      mv caddy $out/bin
      runHook postInstall
    '';

    meta = {
      mainProgram = "caddy";
      maintainers = with lib.maintainers; [jervw];
    };
  }
