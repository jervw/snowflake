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
      };

      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        OfferToSaveLogins = false;
        DisablePocket = true;
        DisableFirefoxAccounts = false;

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };
      };
    };
  };
}
