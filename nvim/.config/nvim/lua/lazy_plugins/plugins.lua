return {
  "windwp/nvim-autopairs",
  "folke/which-key.nvim",
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'mattn/emmet-vim',
  'rebelot/kanagawa.nvim',
  {'williamboman/mason.nvim', lazy=false},
  {'williamboman/mason-lspconfig.nvim', lazy=false},
  {'neovim/nvim-lspconfig', lazy=false},
  {'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  {
    'stevearc/oil.nvim',
   ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end
  }

}
