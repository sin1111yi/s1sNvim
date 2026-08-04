-- plugins/custom/utils/git-head.lua — Git branch + status icon for bufferline offset
-- Module-level cache, refreshed by gitsigns.lua on GitSignsUpdate (and when
-- the async ahead/behind fetch completes). The bufferline offset text reads
-- this cache instead of vim.b directly, so it works regardless of which
-- buffer is active when the tabline renders.

local M = {}

local cache = nil -- { head = string, dirty = boolean, ahead = number?, behind = number? }

-- Called from gitsigns.lua with a buffer's gitsigns_status_dict and
-- gitsigns_ahead_behind (both optional; nil outside a git repo).
function M.update(sd, ab)
  if not sd or not sd.head or sd.head == '' then
    cache = nil
    return
  end
  cache = {
    head = sd.head,
    dirty = (sd.added or 0) + (sd.changed or 0) + (sd.removed or 0) > 0,
    ahead = ab and ab.ahead or nil,
    behind = ab and ab.behind or nil,
  }
end

-- Returns "✓ main" (clean) / "● main" (dirty) with optional ⇡/⇣ counts,
-- or nil when not inside a git repo.
function M.get()
  if not cache then return nil end
  local icon = cache.dirty and '●' or '✓'
  local suffix = ''
  local a, b = cache.ahead, cache.behind
  if a and a > 0 and b and b > 0 then
    suffix = ' ⇡' .. a .. '⇣' .. b
  elseif a and a > 0 then
    suffix = ' ⇡' .. a
  elseif b and b > 0 then
    suffix = ' ⇣' .. b
  end
  return icon .. ' ' .. cache.head .. suffix
end

return M
