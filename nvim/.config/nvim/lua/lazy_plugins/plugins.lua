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
  }
}
