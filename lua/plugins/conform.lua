-- plugins/conform.lua — Code formatting (conform.nvim, lazy spec)
-- VeryLazy (equivalent to old UIEnter); format_on_save must be in place
-- before the first BufWritePre. Manual format via <leader>xf.
-- Formatters (stylua/ruff/rustfmt/clang-format/etc.) must be installed
-- (Mason or system packages).

return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  commit = '619363c30309d29ffa631e67c8183f2a72caa373', -- migration pin
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        sh = { 'shfmt' },
        toml = { 'taplo' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    })
  end,
}
