{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.voxtype;
  voxtypeSelector = pkgs.writeShellApplication {
    name = "voxtype-language";
    runtimeInputs = [pkgs.noctalia pkgs.systemd];
    text = ''
      selection="$(printf '%s\n' Auto English Finnish Japanese Off | noctalia dmenu -p 'Voxtype language')"

      case "$selection" in
        Auto) language="auto" ;;
        English) language="en" ;;
        Finnish) language="fi" ;;
        Japanese) language="ja" ;;
        Off)
          systemctl --user stop voxtype.service
          exit 0
          ;;
        *) exit 0 ;;
      esac

      systemctl --user set-environment "VOXTYPE_LANGUAGE=$language"
      systemctl --user restart voxtype.service
    '';
  };
in {
  options.${namespace}.services.voxtype = {
    enable = lib.mkEnableOption "Voxtype speech-to-text";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [voxtypeSelector];

    services.voxtype = {
      enable = true;
      package = pkgs.voxtype-vulkan;
      loadModels = ["large-v3-turbo"];
      settings = {
        engine = "whisper";
        output.mode = "paste";

        hotkey.enabled = false;
        osd.enabled = false;

        whisper = {
          model = "large-v3-turbo";
          language = "auto";
        };
      };
    };
  };
}
