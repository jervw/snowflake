{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
  writeText,
}: let
  # Upstream's `hid` module uses the hidapi libusb backend, so both the raw
  # USB node and the hidraw node need to be accessible. uaccess only applies
  # to rules that sort before 73-seat-late.rules.
  udevRules = writeText "70-zoneout.rules" (lib.concatMapStrings (pid: ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="${pid}", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="${pid}", TAG+="uaccess"
  '') ["0fa8" "0ec2"]);
in
  python3Packages.buildPythonApplication {
    pname = "zoneout";
    version = "0.1.0-unstable-2026-07-21";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "marcinjakubowski";
      repo = "zoneout";
      rev = "49ebedb178f10c84c7e42e0e946c0ac971d08376";
      hash = "sha256-bZoEeR18O1ODkXbJilwReeGb2Pe6UslFts06P/URnt4=";
    };

    build-system = [python3Packages.setuptools];

    dependencies = with python3Packages; [
      hidapi
      pyqt6
    ];

    nativeBuildInputs = [qt6.wrapQtAppsHook];

    # qtdeclarative provides the QtQuick.Controls/Layouts QML modules.
    buildInputs = [
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtwayland
    ];

    dontWrapQtApps = true;

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';

    postInstall = ''
      install -Dm444 desktop/zoneout.desktop -t $out/share/applications
      install -Dm444 src/zoneout/gui/resources/zoneout.png \
        $out/share/icons/hicolor/512x512/apps/zoneout.png
      install -Dm444 ${udevRules} $out/lib/udev/rules.d/70-zoneout.rules
    '';

    pythonImportsCheck = ["zoneout"];

    meta = {
      description = "Linux controller for Sony INZONE headsets";
      homepage = "https://github.com/marcinjakubowski/zoneout";
      license = lib.licenses.mit;
      mainProgram = "zoneout";
      platforms = lib.platforms.linux;
    };
  }
