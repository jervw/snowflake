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
        # "--enable-features=AcceleratedVideoDecodeLinuxGL"
        # "--enable-features=AcceleratedVideoDecodeLinuxZeroCopyGL"
        # "--enable-features=VaapiOnNvidiaGPUs"
        # "--enable-features=VaapiIgnoreDriverChecks"
      ];
      joinedArgs = lib.concatStringsSep " " commandLineArgs;

      # override for electron 36
      electronVer = "36.0.0-beta.6";
      electronPkg = pkgs.electron_35-bin.overrideAttrs {
        pname = "electron_36-bin";
        version = electronVer;
        src = pkgs.fetchurl {
          url = "https://github.com/electron/electron/releases/download/v${electronVer}/electron-v${electronVer}-linux-x64.zip";
          sha256 = "sha256-HHKIa4DYobTogRmbdw/hk4fY8+9tbyJ+IjsUknLztAE=";
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
