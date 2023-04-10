{ pkgs, ... }:

{
  home.file.".config/nvim/settings.lua".source = ./init.lua;

  home.packages = with pkgs; [
    # LSP's
    rust-analyzer
    lua-language-server
    rnix-lsp
    pyright

    # Formatters
    nixpkgs-fmt
  ];

  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withRuby = false;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      nightfox-nvim
      barbar-nvim
      nvim-web-devicons
      nvim-ts-rainbow
      indent-blankline-nvim
      nvim-treesitter.withAllGrammars
      null-ls-nvim
      lsp-zero-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lsp
      luasnip

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
        plugin = copilot-lua;
        config = ''
        lua << EOF
        require("copilot").setup({
          suggestion = {
              auto_trigger = true,
              keymap = {
                  accept = "<M-e>",
              },
          },
        })
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
            rainbow = {
              enable = true,
              extended_mode = true,
              max_file_lines = nil,
            },
        })
        EOF
        '';
      }
    ];

    extraConfig = "luafile ~/.config/nvim/settings.lua";
  };
}
