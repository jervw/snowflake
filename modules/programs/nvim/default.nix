{ pkgs, ... }:

{
  home.file.".config/nvim/settings.lua".source = ./init.lua;

  home.packages = with pkgs; [
    # LSP's
    rust-analyzer
    nodejs

    # Formatters
    nixpkgs-fmt
  ];

  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      nightfox-nvim
      barbar-nvim
      nvim-web-devicons
      nvim-cmp
      cmp-nvim-lsp

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

      }
      {
        plugin = nvim-lspconfig;
        config = ''
        lua << EOF
        local lspconfig = require('lspconfig')
        local lsp_defaults = lspconfig.util.default_config

        lsp_defaults.capabilities = vim.tbl_deep_extend(
          'force',
          lsp_defaults.capabilities,
          require('cmp_nvim_lsp').default_capabilities()
        )

        EOF
        '';
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
        })
        EOF
        '';
      }
    ];

    extraConfig = "luafile ~/.config/nvim/settings.lua";
  };
}
