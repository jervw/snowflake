let
  jervw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDbHGOAvDf6oXvhsHFiSQjn8m0tSP7JP2XJUNI2JDnm";
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINB6J9/WuerF3L6FyZvYr4D8ffrAxIW8IPb9Vw39dFfz";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/pd5zQYAXuve8QVj6947m/OTfj3O36Czx6/GUpD1BN";
  fenrir = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDOAj0+XMWCCv/FyM8Y3qh9yfkXn83l+MI7CKeXCSm2d";
  huginn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsLmSM41UUDV2UgLZiUlCVzDDgailNwPiHzKkXkNmMB";

  systems = [loki thor fenrir huginn];
in {
  "cloudflare.age".publicKeys = [jervw] ++ systems;
  "tailscale.age".publicKeys = [jervw] ++ systems;
  "reddit.age".publicKeys = [jervw] ++ systems;
  "openai-karakeep.age".publicKeys = [jervw] ++ systems;
}
