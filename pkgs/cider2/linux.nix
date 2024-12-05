{
  pname,
  version,
  src,
  meta,
  appimageTools,
  makeWrapper,
}: let
  extracted = appimageTools.extractType2 {
    inherit pname src version;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src meta;

    extraInstallCommands = ''
      source '${makeWrapper}/nix-support/setup-hook'

      # FIX
      # wrapProgram "$out/bin/${pname}" \
      #   --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      #   --add-flags '--disable-seccomp-filter-sandbox'

      # TODO Icons missing from root
      # install -m 444 -D '${extracted}/usr/share/icons/hicolor/512x512/apps/${pname}.png' \
      #   "$out/share/icons/hicolor/512x512/apps/${pname}.png"

      install -m 444 -D '${extracted}/${pname}.desktop' \
        "$out/share/applications/${pname}.desktop"
      substituteInPlace "$out/share/applications/${pname}.desktop" \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

    multiArch = false;
    extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  }
