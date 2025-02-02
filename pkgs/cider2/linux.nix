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
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --add-flags '--disable-seccomp-filter-sandbox --ignore-gpu-blocklist --enable-gpu-rasterization --enable-gpu --enable-features=Vulkan,UseSkiaRenderer,VaapiVideoDecoder,CanvasOopRasterization,VaapiVideoEncoder,RawDraw --disable-features=UseChromeOSDirectVideoDecoder --enable-zero-copy --enable-oop-rasterization --enable-raw-draw --enable-accelerated-mjpeg-decode --enable-accelerated-video --enable-native-gpu-memory-buffers'

      install -m 444 -D '${extracted}/cider.png' \
        "$out/share/icons/hicolor/512x512/apps/cider.png"

      install -m 444 -D '${extracted}/${pname}.desktop' \
        "$out/share/applications/${pname}.desktop"
      substituteInPlace "$out/share/applications/${pname}.desktop" \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

    multiArch = false;
    extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  }
