{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      nightfox-nvim
      barbar-nvim
      nvim-ts-rainbow
      nvim-web-devicons

      {
        plugin = impatient-nvim;
        config = "lua require('impatient')";
      }

      {
        plugin = telescope-nvim;
        config = "lua require('telescope').setup()";
      }
      {
        plugin = nvim-autopairs;
        config = "lua require('nvim-autopairs').setup()";
      }
      {
        plugin = neoscroll-nvim;
        config = "lua require('neoscroll').setup()";
      }
      {
        plugin = crates-nvim;
        config = "lua require('crates').setup()";
      }
      {
        plugin = gitsigns-nvim;
        config = "lua require('gitsigns').setup()";
      }
      {
        plugin = lualine-nvim;
        config = "lua require('lualine').setup()";
      }

      {
        plugin = toggleterm-nvim;
        config = ''
        lua << EOF
        require("toggleterm").setup{
          direction = "horizontal",
          size = 15,
          open_mapping = [[<M-j>]]
        }
        EOF
        '';
      }
      {
        plugin = nvim-treesitter;
        config = ''
        lua << EOF
        require("nvim-treesitter.configs").setup({
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil,
            },
            cpp = {
                file = {
                    enable = true,
                    priority = 1,
                    parser = "cpp",
                    conditions = {
                        filetype = "cc",
                    },
                },
            },
        })
        EOF
        '';
      }
    ];

    extraConfig = ''
      syntax enable
      colorscheme carbonfox
      set rnu
      '';
  };
}
