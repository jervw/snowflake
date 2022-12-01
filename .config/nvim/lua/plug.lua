-- [[ packer.lua ]]

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Self
  use 'wbthomason/packer.nvim'
  -- Blazingly fast nvim
  use 'lewis6991/impatient.nvim'

  -- Code completion
  use { 'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/nvim-lsp-installer' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }

  -- Tree shitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- Fuzzy finder
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } } }
  -- Auto close brackets
  use 'windwp/nvim-autopairs'
  -- Icons
  use 'nvim-tree/nvim-web-devicons'
  -- Statusline
  use 'nvim-lualine/lualine.nvim'
  -- Colorscheme
  use { "catppuccin/nvim", as = "catppuccin" }
  -- Tabline
  use 'romgrk/barbar.nvim'
  -- Scrollbar
  use "petertriho/nvim-scrollbar"
  -- Smoothscroll
  use 'karb94/neoscroll.nvim'
  -- Formatting
  use 'sbdchd/neoformat'

  -- [[Language specific]]
  -- Rust crates
  use {
    'saecki/crates.nvim',
    tag = 'v0.2.1',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('crates').setup()
    end,
  }

  -- GLSL
  use 'tikhomirov/vim-glsl'
end)



