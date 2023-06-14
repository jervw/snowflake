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
  };
}
