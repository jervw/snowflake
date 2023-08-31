{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    prefix = "C-a";
    secureSocket = false;

    extraConfig = ''
      set -g renumber-windows on

      # splits
      bind-key , split-window -v
      bind-key . split-window -h

      # vim master race
      setw -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

      # use vim-like keys for splits and windows
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind-key C command-prompt -p "New session name: " "new-session -s '%%'"

      # bind pane and window killing without prompt
      bind-key q kill-pane
      bind-key x kill-window

      set -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g default-terminal "screen-256color"

      # statusbar
      set -g status-position top
      set -g status-interval 1
      set -g automatic-rename on
      set -g automatic-rename-format '#{b:pane_current_path}'

      setw -g window-status-current-style "bg=blue"
      setw -g window-status-current-format '#{pane_current_command}'
      setw -g window-status-format '#{pane_current_command}'
    '';
  };
}

