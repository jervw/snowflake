{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "jervw";
    userEmail = "vuolajere@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
