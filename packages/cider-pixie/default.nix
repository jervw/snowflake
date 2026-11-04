{
  lib,
  stdenvNoCC,
  appimageTools,
  requireFile,
  makeShellWrapper,
  autoPatchelfHook,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  libGL,
  libdrm,
  libgbm,
  libxkbcommon,
  nspr,
  nss,
  gtk3,
  systemd,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxscrnsaver,
  wrapGAppsHook4,
  copyDesktopItems,
  makeDesktopItem,
  gjs,
  gtk4,
  gtk4-layer-shell,
  glib,
  pango,
  graphene,
  gdk-pixbuf,
  gobject-introspection,
  libnotify,
}: let
  pname = "cider-pixie";
  version = "4.1.0";

  # The new Cider client is not published at a stable public URL, so the
  # AppImage has to be added to the store manually:
  #   nix-store --add-fixed sha256 Cider-4.1.0.AppImage
  src = requireFile {
    name = "Cider-${version}.AppImage";
    hash = "sha256-KgbHXWAvwnhp7V+8AE72E0/Fb4aVGmSRs5qPdBb2a5w=";
    message = ''
      Add Cider-${version}.AppImage to the Nix store with:
        nix-store --add-fixed sha256 Cider-${version}.AppImage
    '';
  };

  extracted = appimageTools.extract {inherit pname version src;};
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    dontUnpack = true;
    dontWrapGApps = true;

    # ANGLE dlopens libEGL/libGLESv2 at runtime
    appendRunpaths = [(lib.makeLibraryPath [libGL])];

    nativeBuildInputs = [
      makeShellWrapper
      autoPatchelfHook
      wrapGAppsHook4
      copyDesktopItems
      gobject-introspection
    ];

    # Typelibs for the GJS tray player (resources/gjs/tray-player.js)
    buildInputs = [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      libdrm
      libgbm
      libxkbcommon
      nspr
      nss
      gtk3
      systemd
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxscrnsaver

      glib
      gtk4
      gtk4-layer-shell
      pango
      graphene
      gdk-pixbuf
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "cider-pixie";
        desktopName = "Cider";
        exec = "cider-pixie %U";
        icon = "cider-pixie";
        startupWMClass = "Cider";
        mimeTypes = ["x-scheme-handler/cider"];
        categories = ["Audio" "AudioVideo"];
      })
    ];

    installPhase = ''
      runHook preInstall

      # This Cider ships a Widevine-enabled Electron fork (it uses the
      # `components` API), so the bundled runtime is patched and used as-is
      # instead of nixpkgs' electron.
      mkdir -p $out/share
      cp -r ${extracted} $out/share/cider-pixie
      chmod -R u+w $out/share/cider-pixie
      rm -rf $out/share/cider-pixie/{AppRun,Cider.desktop,Cider.png,.DirIcon,usr,chrome-sandbox}

      install -Dm444 ${extracted}/Cider.png \
        $out/share/icons/hicolor/512x512/apps/cider-pixie.png

      runHook postInstall
    '';

    postFixup = ''
      makeShellWrapper $out/share/cider-pixie/Cider $out/bin/cider-pixie \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --prefix PATH : ${lib.makeBinPath [gjs libnotify]} \
        --set CIDER_GJS_PATH ${lib.getExe gjs}
    '';

    meta = {
      description = "Cider, the rewritten cross-platform Apple Music client";
      homepage = "https://cider.sh";
      license = lib.licenses.unfree;
      mainProgram = "cider-pixie";
      platforms = ["x86_64-linux"];
    };
  }
