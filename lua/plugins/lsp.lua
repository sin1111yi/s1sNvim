-- plugins/lsp.lua — LSP setup (Mason + vim.lsp.config, Neovim 0.12+)
-- Uses built-in vim.lsp.config() instead of deprecated require('lspconfig').setup()
-- See :help lspconfig-nvim-0.11 for migration details.

-- Mason: LSP server installer
local mason_ok, mason = pcall(require, 'mason')
if mason_ok then mason.setup() end

-- mason-lspconfig: auto-install servers (setup only, no setup_handlers)
local ml_ok, ml = pcall(require, 'mason-lspconfig')
if ml_ok then
  ml.setup({
    ensure_installed = { 'rust_analyzer', 'lua_ls', 'clangd', 'taplo' },
    automatic_installation = true,
  })
end

-- LSP keymaps are registered centrally in plugins/custom/plugin-keymaps.lua
-- (applied via plugins/custom/utils/lsp.lua on LspAttach).

-- nvim-cmp capabilities (shared by all servers, set as global default)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then
  capabilities = cmp_lsp.default_capabilities()
end
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
