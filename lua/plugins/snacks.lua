-- plugins/snacks.lua — snacks.nvim module states (lazy spec)
-- VeryLazy (equivalent to old UIEnter); <leader>ff/fb/fg/xg/xl/bd closures
-- require('snacks.*') so the plugin must be on rtp by then.
-- Enabled/disabled is explicit so the config file shows every module's
-- state at a glance.

return {
  'folke/snacks.nvim',
  event = 'VeryLazy',
  config = function()
    require('snacks').setup({
      picker = { enabled = true },        -- fuzzy finder: files/buffers/grep
      animate = { enabled = true },       -- animations
      bufdelete = { enabled = true },     -- safe buffer delete
      dashboard = { enabled = false },    -- startup dashboard
      notifier = { enabled = false },     -- notification system
      notify = { enabled = false },        -- notifier backend
      lazygit = { enabled = true },        -- git TUI
      bigfile = { enabled = false },      -- big file optimization
      debug = { enabled = false },        -- debugging tools
      dim = { enabled = false },          -- dim inactive windows
      explorer = { enabled = false },     -- snacks file explorer
      gh = { enabled = false },           -- GitHub CLI integration
      gitbrowse = { enabled = false },    -- open GitHub pages
      git = { enabled = true },          -- git tools (blame etc.)
      health = { enabled = true },       -- health checks
      image = { enabled = false },        -- image preview in terminal
      indent = { enabled = false },       -- indent guides
      input = { enabled = false },        -- vim.ui.input styling
      profiler = { enabled = false },     -- performance profiler
      quickfile = { enabled = false },    -- quick recent files
      rename = { enabled = false },       -- rename tools
      scratch = { enabled = false },      -- scratch buffers
      scroll = { enabled = true },       -- smooth scrolling
      statuscolumn = { enabled = false }, -- enhanced status column
      terminal = { enabled = false },     -- terminal integration
      toggle = { enabled = false },       -- toggle helpers
      words = { enabled = false },        -- LSP reference highlight
      zen = { enabled = false },          -- zen mode
      scope = { enabled = false },        -- buffer scopes
      keymap = { enabled = false },       -- keymap helpers
      layout = { enabled = true },       -- layout system (picker internal dep)
    })
  end,
}
