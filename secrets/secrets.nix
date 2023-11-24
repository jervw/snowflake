let
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk7bYxT0obpeDc9w/6n1pUyRv0G/3irfTnutOneH4yb";
in {
  "plex.age".publicKeys = [loki];
  "cloudlfare.age".publicKeys = [loki];
}
