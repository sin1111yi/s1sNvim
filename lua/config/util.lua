--- config/util.lua — Shared helpers for deferred plugin loading
--- All plugin .setup() calls go through try_load() to gracefully skip
--- uninstalled plugins (first-run) without pcall noise.

local M = {}

--- Try to require and configure a plugin module.
--- Returns the module on success, nil on failure.
---@param name string Module name passed to require()
---@param setup fun(mod: any)? Optional setup function called with loaded module
---@return any|nil
function M.try_load(name, setup)
  local ok, mod = pcall(require, name)
  if not ok then
    return nil
  end
  if setup then
    local ok_setup, err = pcall(setup, mod)
    if not ok_setup then
      vim.notify(string.format('Plugin setup error [%s]: %s', name, err), vim.log.levels.WARN)
    end
  end
  return mod
end

--- Apply a colorscheme safely, retrying on UIEnter if the plugin isn't ready.
---@param name string Colorscheme name
function M.set_colorscheme(name)
  local ok, _ = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.api.nvim_create_autocmd('UIEnter', {
      once = true,
      callback = function()
        pcall(vim.cmd.colorscheme, name)
      end,
    })
  end
end

return M
