{
  programs.git = {
    enable = true;
    userName = "jervw";
    userEmail = "jervw@pm.me";

    ignores = [
      ".direnv/"
      ".env"
      ".envrc"
    ];

    extraConfig = {
      init = {defaultBranch = "main";};
      push.autoSetupRemote = true;
    };

    aliases = {
      fuck = "commit --amend --no-edit";
      s = "status --short";
      ss = "status";
    };

    lfs = {
      enable = true;
    };

    signing = {
      key = "56C25B5B20756352B4B0E17EF188371747DA5895";
      signByDefault = true;
    };
  };
}
