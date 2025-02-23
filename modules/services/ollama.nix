{pkgs, ...}: {
  environment.systemPackages = [pkgs.alpaca pkgs.smartcat];

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    models = "/mnt/storage/ollama-models";
  };
}
