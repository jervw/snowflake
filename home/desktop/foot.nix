_: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font Mono:size=14";
        pad = "10x10 center";
        notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
        selection-target = "clipboard";
      };

      scrollback = {
        lines = 10000;
        multiplier = 3;
      };

      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file";
        uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
      };

      cursor = {
        style = "beam";
        color = "dfdfe0 dfdfe0";
        beam-thickness = 1;
      };

      colors = {
        alpha = 0.9;
        foreground = "cdcecf";
        background = "192330";
        regular0 = "393b44";
        regular1 = "c94f6d";
        regular2 = "81b29a";
        regular3 = "dbc074";
        regular4 = "719cd6";
        regular5 = "9d79d6";
        regular6 = "63cdcf";
        regular7 = "dfdfe0";
        bright0 = "575860";
        bright1 = "d16983";
        bright2 = "8ebaa4";
        bright3 = "e0c989";
        bright4 = "86abdc";
        bright5 = "baa1e2";
        bright6 = "7ad4d6";
        bright7 = "e4e4e5";
      };
    };
  };
}
