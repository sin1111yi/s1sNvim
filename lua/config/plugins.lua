-- config/plugins.lua — Plugin declarations via vim.pack
-- vim.pack = built-in plugin manager (Neovim 0.12+, experimental)
-- NOTE: This file only declares plugins. All .setup() calls are deferred
-- to config/lazy.lua to avoid 'module not found' on first install.

local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
  -- Colorscheme
  gh('catppuccin/nvim'),

  -- Treesitter (syntax highlighting, code navigation)
  gh('nvim-treesitter/nvim-treesitter'),

  -- Key binding management
  gh('folke/which-key.nvim'),

  -- File type icons (used by lualine, which-key, dressing, etc.)
  gh('nvim-tree/nvim-web-devicons'),

  -- Lightweight icons (alternative icon provider)
  gh('echasnovski/mini.icons'),

  -- UI enhancement
  gh('stevearc/dressing.nvim'),

  -- Buffer tab bar
  gh('akinsho/bufferline.nvim'),

  -- File explorer
  gh('nvim-tree/nvim-tree.lua'),

  -- snacks.nvim (picker + utility modules, folke)
  gh('folke/snacks.nvim'),

  -- Surround text objects (ys/ds/cs style)
  gh('echasnovski/mini.surround'),

  -- Code formatting
  gh('stevearc/conform.nvim'),

  -- Flash jump navigation
  gh('folke/flash.nvim'),

  -- LSP infrastructure
  gh('neovim/nvim-lspconfig'),
  gh('williamboman/mason.nvim'),
  gh('williamboman/mason-lspconfig.nvim'),

  -- Autocompletion
  gh('hrsh7th/nvim-cmp'),
  gh('hrsh7th/cmp-nvim-lsp'),
  gh('hrsh7th/cmp-buffer'),
  gh('hrsh7th/cmp-path'),
  gh('L3MON4D3/LuaSnip'),

  -- Statusline
  gh('nvim-lualine/lualine.nvim'),

  -- Git integration
  gh('lewis6991/gitsigns.nvim'),

  -- Comment toggling
  gh('numToStr/Comment.nvim'),
})
