-- plugins/custom/plugin-keymaps.lua — Centralized plugin keybindings
-- Loaded on UIEnter (once), after which-key so wk is available.
-- ALL keybindings are declared in this file. Mechanisms live in
-- plugins/custom/utils/ (lsp: LspAttach applier, cmp: mapping builder,
-- snacks-picker: picker entry points, tree-root: nvim-tree root helper).

local wk = require('which-key')

--------------------------------------------------------------------
-- Window group: <leader>w
--------------------------------------------------------------------
wk.add({
  { '<leader>w', group = 'window' },
  { '<leader>wh', '<C-w>h', desc = 'Window left' },
  { '<leader>wj', '<C-w>j', desc = 'Window down' },
  { '<leader>wk', '<C-w>k', desc = 'Window up' },
  { '<leader>wl', '<C-w>l', desc = 'Window right' },
  { '<leader>ws', ':split<CR>', desc = 'Split horizontal' },
  { '<leader>wv', ':vsplit<CR>', desc = 'Split vertical' },
  { '<leader>wc', ':close<CR>', desc = 'Close window' },
  { '<leader>wq', ':quit<CR>', desc = 'Quit window' },
  { '<leader>wo', ':only<CR>', desc = 'Only this window' },
  { '<leader>w=', '<C-w>=', desc = 'Equalize windows' },
  { '<leader>w+', '<C-w>+', desc = 'Increase height' },
  { '<leader>w-', '<C-w>-', desc = 'Decrease height' },
  { '<leader>w>', '<C-w>>', desc = 'Increase width' },
  { '<leader>w<', '<C-w><', desc = 'Decrease width' },
})

--------------------------------------------------------------------
-- Buffer group: <leader>b (+ Tab cycles buffers)
--------------------------------------------------------------------
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })

-- Flash jump: f/F/t/T are enhanced by flash's char plugin automatically
-- (type a char, labels appear on every match). No extra keymaps needed.

wk.add({
  { '<leader>b', group = 'buffer' },
  { '<leader>bd', function() require('snacks.bufdelete').delete() end, desc = 'Delete buffer' },
  { '<leader>bn', '<cmd>bnext<CR>', desc = 'Next buffer' },
  { '<leader>bp', '<cmd>bprevious<CR>', desc = 'Previous buffer' },
  { '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', desc = 'Close other buffers' },
  { '<leader>bl', require('plugins.custom.utils.snacks-picker').buffers, desc = 'Buffer picker' },
})

--------------------------------------------------------------------
-- Find group: <leader>f (snacks picker)
--------------------------------------------------------------------
wk.add({
  { '<leader>f', group = 'find' },
  { '<leader>ff', require('plugins.custom.utils.snacks-picker').files, desc = 'Find files' },
  { '<leader>fb', require('plugins.custom.utils.snacks-picker').buffers, desc = 'Find buffers' },
  { '<leader>fg', require('plugins.custom.utils.snacks-picker').grep, desc = 'Grep files' },
})

--------------------------------------------------------------------
-- File explorer group: <leader>e (nvim-tree)
--------------------------------------------------------------------
wk.add({
  { '<leader>e', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file explorer' },
  { '<leader>ed', require('plugins.custom.utils.tree-root').open_dir, desc = 'Open directory' },
  { '<leader>er', require('plugins.custom.utils.tree-root').root_to_cwd, desc = 'Tree root to cwd' },
})

--------------------------------------------------------------------
-- Extra group: <leader>x (enhancement tools)
-- xg/xl: lazygit. Enhancement features live here.
--------------------------------------------------------------------
wk.add({
  { '<leader>x', group = 'extra' },
  { '<leader>xg', function() require('snacks.lazygit').open() end, desc = 'Open lazygit' },
  { '<leader>xl', function() require('snacks.lazygit').log() end, desc = 'Git log' },
  { '<leader>xf', function() require('conform').format() end, desc = 'Format file' },
  { '<leader>xx', function()
      local total = 0
      local counts = vim.diagnostic.count()
      for _, n in pairs(counts) do total = total + n end
      if total > 0 then require('trouble').toggle('diagnostics')
      else vim.notify('No diagnostics', vim.log.levels.INFO) end
    end, desc = 'Diagnostics' },
  { '<leader>xq', function()
      if #vim.fn.getqflist() > 0 then require('trouble').toggle('quickfix')
      else vim.notify('Quickfix is empty', vim.log.levels.INFO) end
    end, desc = 'Quickfix list' },
  { '<leader>xL', function()
      if #vim.fn.getloclist(0) > 0 then require('trouble').toggle('loclist')
      else vim.notify('Location list is empty', vim.log.levels.INFO) end
    end, desc = 'Location list' },
  { '<leader>xh', ':TriggerHelp<CR>', desc = 'Trigger help' },
})

--------------------------------------------------------------------
-- Terminal group: <leader>t (toggleterm)
--------------------------------------------------------------------
wk.add({
  { '<leader>t', group = 'terminal' },
  { '<leader>tt', '<cmd>ToggleTerm<CR>', desc = 'Toggle terminal' },
  { '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', desc = 'Vertical terminal' },
  { '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', desc = 'Float terminal' },
})

--------------------------------------------------------------------
-- Settings group: <leader>r (rn toggle relative number, rR reload config)
--------------------------------------------------------------------
wk.add({
  { '<leader>r', group = 'settings' },
  { '<leader>rn', ':set relativenumber!<CR>', desc = 'Toggle relative number' },
  { '<leader>rw', ':set wrap!<CR>', desc = 'Toggle wrap' },
  { '<leader>rh', ':set hlsearch!<CR>', desc = 'Toggle search highlight' },
  { '<leader>rc', ':set list!<CR>', desc = 'Toggle invisible chars' },
  { '<leader>rs', ':set ignorecase!<CR>', desc = 'Toggle case-sensitive search' },
  { '<leader>rk', function()
      if vim.o.colorcolumn == '' then vim.o.colorcolumn = '80'
      else vim.o.colorcolumn = '' end
    end, desc = 'Toggle color column' },
})

--------------------------------------------------------------------
-- Uncommon group: <leader>u (rarely used operations)
-- ut*: tab page operations (kept out of frequently-used groups)
--------------------------------------------------------------------
wk.add({
  { '<leader>u', group = 'uncommon' },
  { '<leader>utn', ':tabnew<CR>', desc = 'New tab' },
  { '<leader>utc', ':tabclose<CR>', desc = 'Close tab' },
  { '<leader>uto', ':tabonly<CR>', desc = 'Close other tabs' },
})

--------------------------------------------------------------------
-- Quit group: <leader>q
--------------------------------------------------------------------
wk.add({
  { '<leader>q', ':quit<CR>', desc = 'Quit' },
  { '<leader>qq', ':wqa<CR>', desc = 'Save all and quit' },
})

--------------------------------------------------------------------
-- LSP buffer-local mappings (applied on LspAttach by utils/lsp.lua)
-- Neovim 0.11+ built-in defaults already provide:
--   K = hover, grn = rename, grr = references, gri = implementation,
--   grt = type definition, gra = code action, CTRL-S = signature help,
--   gO = document symbols, [d / ]d = diagnostics
-- We only set the traditional extras (gd/gD/gi).
--------------------------------------------------------------------
require('plugins.custom.utils.lsp').setup({
  { 'n', 'gd', vim.lsp.buf.definition, 'Go to definition' },
  { 'n', 'gD', vim.lsp.buf.declaration, 'Go to declaration' },
  { 'n', 'gi', vim.lsp.buf.implementation, 'Go to implementation' },
})

--------------------------------------------------------------------
-- nvim-cmp insert-mode mappings (built by utils/cmp.lua; minimal set,
-- other defaults come from cmp.mapping.preset.insert)
--------------------------------------------------------------------
local cmp_map = {
  ['<Tab>'] = function(cmp)
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif pcall(require('luasnip').expand_or_jumpable) then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' })
  end,
  ['<S-Tab>'] = function(cmp)
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif pcall(require('luasnip').jumpable, -1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  end,
  ['<CR>'] = function(cmp) return cmp.mapping.confirm({ select = true }) end,
}

return { cmp_map = cmp_map }
