{ pkgs, ... }:

{
programs.zsh = {
    enable = true;

    dotDir = ".config/zsh/";

    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    initExtra = ''
      PROMPT='%F{yellow}%~ %F{green}➜ %F{reset}'
      export EDITOR=nvim
      export VISUAL=nvim

      bindkey -e
    '';

    dirHashes = {
      dots = "$HOME/.nix-setup/";
    };

    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      nano = "nvim";
      cat = "bat --paging=never --style=plain";
      ls = "exa -a --icons";
      tree = "exa --tree --icons";
      whereami = "curl ipinfo.io/city";
      rebuild = "doas nixos-rebuild switch --flake #desktop";
    };

    history = {
      save = 1000;
      size = 1000;
      path = "$HOME/.cache/zsh_history";
    };
  };
}
