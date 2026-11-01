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
        "privacy.resistFingerprinting" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";

        "identity.fxaccounts.enabled" = true;
      };

      policies = {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        OfferToSaveLogins = false;
        DisablePocket = true;
        DisableFirefoxAccounts = false;

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
          SkipOnboarding = true;
        };
      };
    };
  };
}
