{pkgs, ...}: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      set fish_greeting # Disable greeting
      direnv hook fish | source

      function twitch
        kill -9 $(ps -o ppid -p $fish_pid)
        nohup streamlink -p mpv --quiet --twitch-low-latency twitch.tv/"$argv" best &
        nohup chatterino -c "$argv" &>/dev/null
      end
    '';

    shellAliases = {
      doas = "sudo";
      nvim = "hx";
      nano = "hx";
      yz = "yazi";
      ls = "eza --icons";
      tree = "eza --tree --icons";
      whereami = "curl ipinfo.io/city";
    };
  };

  home.packages = with pkgs; [
    fishPlugins.autopair
    fishPlugins.fzf
  ];
}
