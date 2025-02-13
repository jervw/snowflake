{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      userName = "jervw";
      userEmail = "jervw@pm.me";

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

      signing = {
        key = "56C25B5B20756352B4B0E17EF188371747DA5895";
        signByDefault = true;
      };
    };
    gh = {
      enable = true;
      settings = {
        editor = "hx";
        prompt = "enabled";
        git_protocol = "ssh";
      };
      extensions = with pkgs; [
        gh-eco
        gh-markdown-preview
        gh-copilot
        gh-dash
      ];
    };
  };
}
