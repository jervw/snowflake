{
  lib,
  fetchFromCodeberg,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "nixpkgs-webhook";
  version = "0-unstable-2026-08-12";

  pyproject = false;

  src = fetchFromCodeberg {
    owner = "jervw";
    repo = "nixpkgs-webhook";
    rev = "28a7c9d07b02553ee5c5dde028172bb68153d3b4";
    hash = "sha256-JUd173tGmvmpi4jH22XNiEetA+7oTsR2Nxfr6R6eXls=";
  };

  dependencies = with python3Packages; [
    requests
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 nixpkgs.py $out/bin/nixpkgs-webhook
    runHook postInstall
  '';

  meta = {
    description = "Send a webhook when NixOS channel revisions change";
    homepage = "https://codeberg.org/jervw/nixpkgs-webhook";
    platforms = lib.platforms.linux;
  };
}
