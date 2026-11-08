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
    programs.librewolf = {
      enable = true;
      inherit configPath;

      settings = {
        "identity.fxaccounts.enabled" = true;
        "permissions.default.shortcuts" = 2;
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
