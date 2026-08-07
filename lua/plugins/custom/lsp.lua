-- plugins/utils/lsp.lua — LSP keymap applier
-- Mechanism only: consumes a mapping table declared in plugin-keymaps.lua
-- and applies it as buffer-local mappings on LspAttach.

local wk = require('which-key')

local M = {}

function M.setup(mappings)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true, noremap = true }

      for _, m in ipairs(mappings) do
        local mode, lhs, rhs, desc = m[1], m[2], m[3], m[4]
        vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', opts, { desc = desc }))
      end

      -- Notify which-key of buffer-local <Leader> mappings
      local wk_maps = {}
      for _, m in ipairs(mappings) do
        if m[2]:match('^<[Ll]eader>') then
          table.insert(wk_maps, { m[2], m[3], desc = m[4], buffer = ev.buf })
        end
      end
      if #wk_maps > 0 then
        wk.add(wk_maps)
      end
    end,
  })
end

return M
