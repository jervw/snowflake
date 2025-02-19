_: {
  systemd.services.trasher = {
    description = "Clean system and user trash directories";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        /bin/sh -c "find /home -type d -name '.Trash-*' -exec rm -rf {} + \
        && rm -rf /home/*/.local/share/Trash/{files,info}/*"
      '';
      User = "root";
    };
  };

  systemd.timers.trasher = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "trasher.service";
    };
  };
}
