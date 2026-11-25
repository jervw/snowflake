{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.librewolf;

  configPath = "${config.xdg.configHome}/librewolf/librewolf";
in {
  options.${namespace}.programs.apps.librewolf = {
    enable = lib.mkEnableOption "Enable LibreWolf";
  };

  config = mkIf cfg.enable {
    # The HM module hardcodes the legacy ~/.librewolf overrides path, but with an
    # XDG profile LibreWolf only reads it from next to profiles.ini.
    home.file.".librewolf/librewolf.overrides.cfg".enable = false;
    xdg.configFile."librewolf/librewolf/librewolf.overrides.cfg".text =
      config.home.file.".librewolf/librewolf.overrides.cfg".text;

    programs.librewolf = {
      enable = true;
      inherit configPath;

      settings = {
        "identity.fxaccounts.enabled" = true;
      };

      policies = {
        AutofillAddressEnabled = false;

        SearchEngines = {
          Add = [
            {
              Name = "Kagi";
              URLTemplate = "https://kagi.com/search?q={searchTerms}";
              SuggestURLTemplate = "https://kagi.com/api/autosuggest?q={searchTerms}";
              IconURL = "https://kagi.com/favicon.ico";
              Method = "GET";
            }
          ];
          Default = "Kagi";
        };
      };
    };
  };
}
