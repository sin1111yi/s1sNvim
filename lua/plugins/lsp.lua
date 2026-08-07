-- plugins/lsp.lua — LSP setup (nvim-lspconfig, lazy spec)
-- Uses built-in vim.lsp.config() instead of deprecated require('lspconfig').setup()
-- See :help lspconfig-nvim-0.11 for migration details.
-- Loads on first BufReadPre/BufNewFile (slightly earlier than old FileType
-- first-match; equivalent). Deps: mason, mason-lspconfig (declared in
-- mason.lua), cmp-nvim-lsp (declared in cmp.lua).

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- LSP keymaps are registered centrally in plugins/custom/plugin-keymaps.lua
    -- (applied via plugins/custom/lsp.lua on LspAttach).

    -- nvim-cmp capabilities (shared by all servers, set as global default)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities()
    vim.lsp.config('*', { capabilities = capabilities })

    -- ── Server configs ────────────────────────────────────────────
    -- nvim-lspconfig provides defaults for cmd/filetypes/root_markers.
    -- We only override settings sections; vim.lsp.enable() activates.

    -- Rust Analyzer
    vim.lsp.config('rust_analyzer', {
      settings = {
        ['rust-analyzer'] = {
          cargo = { allFeatures = true, buildScripts = { enable = true } },
          checkOnSave = true, -- newer rust-analyzer: boolean; command moved to check
          check = { command = 'clippy' },
          procMacro = { enable = true },
          inlayHints = {
            enable = true, typeHints = true, parameterHints = true,
            chainingHints = true, closingBraceHints = true,
          },
        },
      },
    })
    vim.lsp.enable('rust_analyzer')

    -- Lua Language Server
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })
    vim.lsp.enable('lua_ls')

    -- clangd (C/C++)
    vim.lsp.config('clangd', {
      cmd = {
        'clangd', '--background-index', '--clang-tidy',
        '--header-insertion=iwyu',
      },
    })
    vim.lsp.enable('clangd')

    -- Diagnostic display
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = 'rounded', source = true },
    })
  end,
}
