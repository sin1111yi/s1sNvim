-- plugins/custom/plugin-keymaps.lua — Centralized plugin keybindings
-- Loaded on UIEnter (once), after which-key so wk is available.
-- ALL keybindings are declared in this file. Mechanisms live in
-- plugins/custom/utils/ (buffer-picker: picker fn, cmp: mapping builder,
-- lsp: LspAttach applier).

local wk = require('which-key')

--------------------------------------------------------------------
-- <Leader> mappings (which-key popup)
--------------------------------------------------------------------
wk.add({
  -- Buffer group
  { '<leader>b', group = 'buffer' },
  { '<leader>bd', ':bdelete<CR>', desc = 'Delete buffer' },
  { '<leader>bn', ':bnext<CR>', desc = 'Next buffer' },
  { '<leader>bp', ':bprevious<CR>', desc = 'Previous buffer' },
  { '<leader>bl', require('plugins.custom.utils.buffer-picker').picker, desc = 'Buffer picker' },

  -- Tab group
  { '<leader>t', group = 'tab' },
  { '<leader>tn', ':tabnew<CR>', desc = 'New tab' },
  { '<leader>tc', ':tabclose<CR>', desc = 'Close tab' },
  { '<leader>to', ':tabonly<CR>', desc = 'Close other tabs' },

  -- Quickfix group
  { '<leader>c', group = 'quickfix' },
  { '<leader>co', ':copen<CR>', desc = 'Open quickfix list' },
  { '<leader>cc', ':cclose<CR>', desc = 'Close quickfix list' },

  -- Location group
  { '<leader>l', group = 'location' },
  { '<leader>lo', ':lopen<CR>', desc = 'Open location list' },
  { '<leader>lc', ':lclose<CR>', desc = 'Close location list' },

  -- Single actions
  { '<leader>w', ':write<CR>', desc = 'Save file' },
  { '<leader>q', ':quit<CR>', desc = 'Quit' },
})

--------------------------------------------------------------------
-- NvimTree
--------------------------------------------------------------------
wk.add({
  { '<leader>m', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file explorer' },
  { '<leader>mr', require('plugins.custom.utils.tree-root').root_to_cwd, desc = 'Tree root to cwd' },
})

--------------------------------------------------------------------
-- LSP buffer-local mappings (applied on LspAttach by utils/lsp.lua)
-- Neovim 0.11+ built-in defaults already provide:
--   K = hover, grn = rename, grr = references, gri = implementation,
--   grt = type definition, gra = code action, CTRL-S = signature help,
--   gO = document symbols, CTRL-] = go-to-definition (via tagfunc)
-- We only set extras (gd/gD/gi/C-k) + <Leader> mappings for which-key.
--------------------------------------------------------------------
require('plugins.custom.utils.lsp').setup({
  { 'n', 'gd', vim.lsp.buf.definition, 'Go to definition' },
  { 'n', 'gD', vim.lsp.buf.declaration, 'Go to declaration' },
  { 'n', 'gi', vim.lsp.buf.implementation, 'Go to implementation' },
  { 'n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help' },
  { 'n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol' },
  { 'n', '<leader>ca', vim.lsp.buf.code_action, 'Code action' },
  { 'n', '<leader>D', vim.lsp.buf.type_definition, 'Type definition' },
  { 'n', '<leader>e', vim.diagnostic.open_float, 'Show diagnostic' },
})

--------------------------------------------------------------------
-- nvim-cmp insert-mode mappings (built by utils/cmp.lua at setup time;
-- values are thunks receiving the cmp module, so cmp is not loaded early)
--------------------------------------------------------------------
local cmp_map = {
  ['<C-b>'] = function(cmp) return cmp.mapping.scroll_docs(-4) end,
  ['<C-f>'] = function(cmp) return cmp.mapping.scroll_docs(4) end,
  ['<C-Space>'] = function(cmp) return cmp.mapping.complete() end,
  ['<C-e>'] = function(cmp) return cmp.mapping.abort() end,
  ['<CR>'] = function(cmp) return cmp.mapping.confirm({ select = true }) end,
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
}

return { cmp_map = cmp_map }
