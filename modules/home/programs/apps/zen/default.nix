{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.zen;
in {
  options.${namespace}.programs.apps.zen = {
    enable = lib.mkEnableOption "Enable zen-browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;

      profiles.default.presets.betterfox.enable = true;

      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        OfferToSaveLogins = false;

        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          MoreFromMozilla = false;
        };
      };
    };
  };
}
