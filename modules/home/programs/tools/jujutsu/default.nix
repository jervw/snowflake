{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.programs.tools.jujutsu;
in {
  options.${namespace}.programs.tools.jujutsu = {
    enable = mkEnableOption "Enable jujutsu";
    userName = mkOpt types.str user.name "The name to configure jujutsu with.";
    userEmail = mkOpt types.str user.email "The email to configure jujutsu with.";
    signByDefault = mkOpt types.bool true "Whether to sign commits by default.";
    signingKey =
      mkOpt types.str "85406535C615A548"
      "The key ID to sign commits with.";
  };

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };

        signing = {
          backend = "gpg";
          behavior =
            if cfg.signByDefault
            then "own"
            else "drop";
          key = cfg.signingKey;
        };
      };
    };
  };
}
