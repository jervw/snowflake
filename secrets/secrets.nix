let
  jervw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDbHGOAvDf6oXvhsHFiSQjn8m0tSP7JP2XJUNI2JDnm ";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7Xm5sE+PbatmSLaX5PT89S956tclHqvc9NUuzzCmeF";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/pd5zQYAXuve8QVj6947m/OTfj3O36Czx6/GUpD1BN";
  systems = [loki thor];
in {
  "cloudflare.age".publicKeys = [jervw] ++ systems;
}
