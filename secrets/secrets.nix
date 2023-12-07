let
  loki = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGB/NVaAE2OLK0giYC2xxf/TPx5/TFDDSuHAx7TRRfec";
  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/pd5zQYAXuve8QVj6947m/OTfj3O36Czx6/GUpD1BN";
in {
  "pia.age".publicKeys = [loki thor];
}
