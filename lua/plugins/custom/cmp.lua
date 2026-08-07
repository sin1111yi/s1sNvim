-- plugins/utils/cmp.lua — nvim-cmp mapping builder
-- Mechanism only: consumes a mapping table of thunks declared in
-- plugin-keymaps.lua and builds cmp.mapping.preset.insert() output.
-- Thunks receive the cmp module so it is never loaded early.

local M = {}

function M.build(map, cmp)
  local out = {}
  for lhs, thunk in pairs(map) do
    out[lhs] = thunk(cmp)
  end
  return cmp.mapping.preset.insert(out)
end

return M
