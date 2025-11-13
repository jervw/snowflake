{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.graphical.addons.vesktop-fix;
in {
  options.${namespace}.programs.graphical.addons.vesktop-fix = {
    enable = lib.mkEnableOption "Enable Vesktop electron fix";
  };

  config = mkIf cfg.enable (
    let
      # NOTE: Thanks @fazzi
      commandLineArgs = [
        "--disable-features=WebRtcAllowInputVolumeAdjustment" # stop chromium from messing with my mic volume
        # attempt to disable noise suppression? This also disables echo cancellation too tho.
        "--disable-features=ChromeWideEchoCancellation"
        "--enable-features=WaylandLinuxDrmSyncobj" # fix flickering

        # attempt to enable hardware acceleration
        # FIXME: not working on Electron yet?
        "--enable-features=AcceleratedVideoDecodeLinuxGL"
        "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
        "--enable-features=VaapiOnNvidiaGPUs"
        "--enable-features=VaapiIgnoreDriverChecks"
      ];
      joinedArgs = lib.concatStringsSep " " commandLineArgs;

      # override for electron 40
      electronVer = "40.0.0-alpha.4";
      electronPkg = pkgs.electron_39-bin.overrideAttrs {
        pname = "electron_40-bin";
        version = electronVer;
        src = pkgs.fetchurl {
          url = "https://github.com/electron/electron/releases/download/v${electronVer}/electron-v${electronVer}-linux-x64.zip";
          sha256 = "sha256-3sK7SnvH0DYTlzK56UtgeF263V2lwzdcUkOTzVSxcfQ=";
        };
      };
    in {
      home.packages = with pkgs; [
        ((vesktop.override {
            electron = electronPkg;
            withTTS = false;
            withMiddleClickScroll = true;
          })
        .overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
            postFixup = ''
              ${old.postFixup or ""}
              wrapProgramShell $out/bin/vesktop --add-flags "${joinedArgs}"
            '';
          }))
      ];
    }
  );
}
