{
  cmake,
  fetchFromGitHub,
  lib,
  libpulseaudio,
  openssl,
  pkg-config,
  qt6,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "librepods-omarchy";
  version = "1.3.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "thisisgm";
    repo = "omarchy-pods";
    rev = "fff7fec600a5b9a61cdb40e93eccbcceb4b8f824";
    hash = "sha256-CMPeGfsLQQSYL1zsBAXChUHkSVTAoSvRlmHhpQoaK0A=";
  };

  sourceRoot = "source/daemon";
  cmakeFlags = ["-DBUILD_TESTING=OFF"];

  buildInputs = [
    libpulseaudio
    openssl
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtquick3d
    qt6.qttools
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  # The bundled unit assumes an imperative installation in ~/.local. The
  # AirPods module provides an equivalent unit using the NixOS wrapper.
  postInstall = ''
    rm $out/share/systemd/user/librepods.service
  '';

  meta = {
    description = "LibrePods daemon modified for the omarchy-pods panel plugin";
    homepage = "https://github.com/thisisgm/omarchy-pods";
    license = lib.licenses.gpl3Only;
    mainProgram = "librepods";
    platforms = lib.platforms.linux;
  };
}
