{
  config,
  lib,
  namespace,
  ...
}: let
  inherit (lib) types mkIf mkEnableOption;
  inherit (lib.${namespace}) mkOpt;
  inherit (config.${namespace}) user;

  cfg = config.${namespace}.programs.terminal.tools.git;
in {
  options.${namespace}.programs.terminal.tools.git = {
    enable = mkEnableOption "Enable atuin";
    userName = mkOpt types.str user.name "The name to configure git with.";
    userEmail = mkOpt types.str user.email "The email to configure git with.";
    signByDefault = mkOpt types.bool true "Whether to sign commits by default.";
    signingKey =
      mkOpt types.str "56C25B5B20756352B4B0E17EF188371747DA5895"
      "The key ID to sign commits with.";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      inherit (cfg) includes userName userEmail;

      ignores = [
        ".direnv/"
        ".env"
        ".envrc"
      ];

      aliases = {
        s = "status";
        last = "log -1 HEAD";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
        l = "lg";
      };

      extraConfig = {
        init = {defaultBranch = "main";};
        push.autoSetupRemote = true;
      };

      lfs = {
        enable = true;
      };

      rebase = {
        autoStash = true;
      };

      signing = {
        key = cfg.signingKey;
        inherit (cfg) signByDefault;
      };
    };
  };
}
