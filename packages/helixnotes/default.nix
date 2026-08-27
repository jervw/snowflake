{
  cargo-tauri,
  fetchFromGitLab,
  fetchPnpmDeps,
  jq,
  lib,
  libayatana-appindicator,
  moreutils,
  nodejs,
  pkg-config,
  pnpm,
  pnpmConfigHook,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
}: let
  pname = "helixnotes";
  version = "1.3.5";

  src = fetchFromGitLab {
    owner = "ArkHost";
    repo = "HelixNotes";
    rev = "v${version}";
    hash = "sha256-hJZ93LctJxzeWcJ1CtIMFcKLIKNnd45JE8xEWu3/lW8=";
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version src;

    cargoHash = "sha256-Lf/2f+fyOz9/2XanNxzjImAtSRoDvrRZjzifiql+yI8=";

    pnpmDeps = fetchPnpmDeps {
      inherit pname version src;
      fetcherVersion = 4;
      hash = "sha256-QutzaClzphlmmAgDX+Az4BHsTbu+byhwMoUF/uxdPsI=";
    };

    nativeBuildInputs = [
      cargo-tauri.hook
      jq
      moreutils
      nodejs
      pkg-config
      pnpm
      pnpmConfigHook
      wrapGAppsHook3
    ];

    buildInputs = [
      libayatana-appindicator
      webkitgtk_4_1
    ];

    cargoRoot = "src-tauri";
    buildAndTestSubdir = "src-tauri";

    # Updates are managed by Nix, so disable Tauri's bundled updater.
    postPatch = ''
      jq '
        .bundle.createUpdaterArtifacts = false |
        .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
      ' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    '';

    meta = {
      description = "Local, open-source Markdown note-taking app";
      homepage = "https://helixnotes.com/";
      license = lib.licenses.agpl3Plus;
      mainProgram = "helixnotes";
      platforms = lib.platforms.linux;
    };
  }
