-- config/loader.lua — Plugin lazy-loader
-- Registers event-driven autocmds that require plugin configs on first use.
-- Loaded at startup (via init.lua), so VimEnter-dependent plugins (e.g.
-- mini.starter) still get their event in time.
-- Order matters: which-key before plugin-keymaps, icons before consumers.

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local function on(event, name, callback)
  au(event, {
    group = augroup('Plugin' .. name, { clear = true }),
    once = true,
    callback = callback,
  })
end

-- Colorscheme — UIEnter
on('UIEnter', 'Colorscheme', function() require('plugins.catppuccin') end)

-- Treesitter — BufReadPost
on('BufReadPost', 'Treesitter', function() require('plugins.treesitter') end)

-- Lualine — UIEnter
on('UIEnter', 'Lualine', function() require('plugins.lualine') end)

-- Dressing — UIEnter
on('UIEnter', 'Dressing', function() require('plugins.dressing') end)

-- Bufferline — UIEnter
on('UIEnter', 'Bufferline', function() require('plugins.bufferline') end)

-- Mini.starter — UIEnter
on('UIEnter', 'MiniStarter', function() require('plugins.mini-starter') end)

-- Snacks (picker) — UIEnter
on('UIEnter', 'Snacks', function() require('plugins.snacks') end)

-- NvimTree — UIEnter
on('UIEnter', 'NvimTree', function() require('plugins.nvim-tree') end)

-- Which-key — UIEnter (must load before plugin-keymaps so wk is ready)
on('UIEnter', 'Whichkey', function() require('plugins.which-key') end)

-- Plugin keymaps — UIEnter (after which-key)
on('UIEnter', 'Keymaps', function() require('plugins.custom.plugin-keymaps') end)

-- Devicons — UIEnter
on('UIEnter', 'Devicons', function() require('plugins.devicons') end)

-- Mini.icons — UIEnter
on('UIEnter', 'MiniIcons', function() require('plugins.mini-icons') end)

-- Gitsigns + Comment — BufReadPost
on('BufReadPost', 'GitsignsComment', function()
  require('plugins.gitsigns')
  require('plugins.comment')
end)

-- nvim-cmp — InsertEnter
on('InsertEnter', 'Cmp', function() require('plugins.cmp') end)

-- LSP — first matching FileType
local lsp_filetypes = { 'rust', 'c', 'cpp', 'lua', 'python', 'toml', 'yaml', 'json', 'markdown', 'sh', 'bash' }
au('FileType', {
  group = augroup('PluginLsp', { clear = true }),
  once = true,
  pattern = lsp_filetypes,
  callback = function() require('plugins.lsp') end,
})
