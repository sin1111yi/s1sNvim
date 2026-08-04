-- plugins/keymaps/buffer-picker.lua — Buffer picker component
-- Used by plugin-keymaps.lua for the <leader>bl mapping.

local M = {}

function M.picker()
  local buffers = vim.iter(vim.api.nvim_list_bufs())
    :filter(function(b) return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted end)
    :map(function(b)
      local name = vim.api.nvim_buf_get_name(b)
      local fname = name ~= '' and vim.fn.fnamemodify(name, ':~:.') or '[No Name]'
      local modified = vim.bo[b].modified and ' +' or ''
      return { id = b, label = string.format('%3d%s %s', b, modified, fname) }
    end)
    :totable()

  vim.ui.select(buffers, {
    prompt = 'Buffers',
    format_item = function(item) return item.label end,
  }, function(choice)
    if choice then vim.api.nvim_set_current_buf(choice.id) end
  end)
end

return M
