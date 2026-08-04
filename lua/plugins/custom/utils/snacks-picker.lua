-- plugins/custom/utils/snacks-picker.lua — snacks picker entry points
-- Thin wrappers so plugin-keymaps.lua only declares the mappings.

local M = {}

function M.files()
  require('snacks.picker').files()
end

function M.buffers()
  require('snacks.picker').buffers()
end

function M.grep()
  require('snacks.picker').grep()
end

return M
