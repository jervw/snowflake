{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        websearch
        shell
        rink
      ];
      width = {fraction = 0.2;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = false;
      showResultsImmediately = false;
    };
    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 10,
        )
      '';
      "shell.ron".text = ''
        Config(
          prefix: ":sh",
          shell: None,
        )
      '';
      "websearch.ron".text = ''
        Config(
          prefix: "/",
          engines: [
            Custom(
              name: "Kagi",
              url: "kagi.com/search?q={}",
            ),
            Custom(
              name: "Nix packages",
              url: "search.nixos.org/packages?query={}&channel=unstable",
            ),
            Custom(
              name: "Nix options",
              url: "search.nixos.org/options?query={}&channel=unstable",
            ),
          ],
        )
      '';
    };
    extraCss = ''
      * {
        all: unset;
        transition: 150ms ease-out;
        color: #fff;
        font-family: "Noto Sans", "JetBrainsMono Nerd Font Mono";
        font-size: 1.2rem;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      #main {
        margin-top: 0.5rem;
      }

      #match {
        padding: 3px;
        border-radius: 12px;
      }

      #match:hover,
      #match:selected {
        background: #7FB6E1;
        padding: 0.6rem;
      }

      entry#entry {
        border-color: transparent;
        margin-top: 0.5rem;
      }

      box#main {
        background: rgba(40, 44, 52, 0.5);
        border: 2px solid #7FB6E1;
        border-radius: 12px;
        padding: 0.3rem;
      }
    '';
  };
}
