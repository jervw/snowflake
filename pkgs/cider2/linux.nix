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

      wrapProgram "$out/bin/${pname}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
        --add-flags '--disable-seccomp-filter-sandbox --enable-features=WebRTCPipeWireCapturer,UsingChromeOSDirectVideoDecoder' \
        --add-flags '--enable-zero-copy --enable-gpu-rasterization --enable-oop-rasterization'

      install -m 444 -D '${extracted}/cider.png' \
        "$out/share/icons/hicolor/512x512/apps/cider.png"

      install -m 444 -D '${extracted}/${pname}.desktop' \
        "$out/share/applications/${pname}.desktop"
      substituteInPlace "$out/share/applications/${pname}.desktop" \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

    multiArch = false;
    extraPkgs = pkgs:
      [pkgs.libnotify]
      ++ appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;
  }
