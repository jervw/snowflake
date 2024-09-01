{
  user,
  config,
  ...
}: {
  services.borgbackup.jobs = let
    excludes = [
      ".cache"
      "*/cache2"
      "*/Cache"
      ".container-diff"
      ".npm/_cacache"
      "*/node_modules"
      "*/_build"
      "*/.tox"
      "*/venv"
      "*/.venv"
      "*/target"
    ];
    borgJob = name: {
      inherit user;
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/jervw/.ssh/id_ed25519";
      environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      repo = "jervw@10.0.0.2:/mnt/storage/Backups/${name}";
      compression = "auto,zstd";
      startAt = "daily";
    };
  in {
    loki-home =
      borgJob "${config.system.name}/persist"
      // rec {
        paths = "/persist/home";
        exclude = map (x: paths + "/" + x) excludes;
      };
  };
}
