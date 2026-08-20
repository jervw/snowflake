{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.programs.tools.git;
in {
  options.${namespace}.programs.tools.git = {
    enable = mkEnableOption "Enable git";
    userName = mkOpt types.str user.name "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    signByDefault = mkOpt types.bool true "Whether to sign commits by default.";
    signingKey =
      mkOpt types.str "85406535C615A548"
      "The key ID to sign commits with.";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };

      ignores = [
        ".direnv/"
        ".env"
        ".envrc"
        "AGENTS.md"
      ];

      lfs = {
        enable = true;
      };

      signing = {
        key = cfg.signingKey;
        format = null;
        inherit (cfg) signByDefault;
      };
    };
  };
}
