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
    enable = lib.mkEnableOption "Enable Zen-browser";
  };

  config = mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        # Browser
        DisableAppUpdate = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        SkipTermsOfUse = true;
        StartDownloadsInTempDirectory = true;

        # Features
        DisableFirefoxScreenshots = true;
        DisableForgetButton = true;
        DisableSetDesktopBackground = true;
        PDFjs.Enabled = false;
        TranslateEnabled = false;

        # Privacy
        DisableTelemetry = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisableProfileImport = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        HttpsOnlyMode = true;

        # Passwords & autofill
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableMasterPasswordCreation = true;
        OfferToSaveLogins = false;

        # AI
        GenerativeAI = {
          Enabled = false;
          Chatbot = false;
          LinkPreviews = false;
          TabGroups = false;
          Locked = false;
        };
      };
    };
  };
}
