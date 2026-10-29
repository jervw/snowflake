{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.${namespace}.programs.apps.librewolf;

  # LibreWolf uses XDG paths unless ~/.librewolf exists.
  configPath = "${config.xdg.configHome}/librewolf/librewolf";
in {
  options.${namespace}.programs.apps.librewolf = {
    enable = lib.mkEnableOption "Enable LibreWolf";
  };

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
      inherit configPath;

      # Deep-merged over LibreWolf's own policies.json, so only additions go here.
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
