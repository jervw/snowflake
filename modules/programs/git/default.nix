{
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "jervw";
    userEmail = "vuolajere@gmail.com";

    extraConfig = {
      init = {defaultBranch = "main";};
    };

    aliases = {
      forgor = "commit --amend --no-edit";
      s = "status --short";
      ss = "status";
    };

    signing = {
      key = "2A19308BA17F69683BB4FF821E3FCE4BF382E951";
      signByDefault = true;
    };
  };
}
