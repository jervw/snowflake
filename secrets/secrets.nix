let
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVFad93QGHi8zi7AxA80mx2MsY+00EeJmvEwXNGUs//";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/pd5zQYAXuve8QVj6947m/OTfj3O36Czx6/GUpD1BN";
in {
  "cloudflare.age".publicKeys = [loki thor];
}
