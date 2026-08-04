-- plugins/snacks.lua — snacks.nvim module states
-- Loaded on UIEnter (once). Enabled/disabled is explicit so the config file
-- shows every module's state at a glance.

local U = require('config.util')
return U.try_load('snacks', function(snacks)
  snacks.setup({
    -- == Enabled ==
    picker = { enabled = true },        -- fuzzy finder: files/buffers/grep (<leader>ff/fb/fg)
    animate = { enabled = true },       -- animations
    bufdelete = { enabled = true },     -- safe buffer delete
    dashboard = { enabled = false },    -- startup dashboard (requires lazy.nvim)
    notifier = { enabled = false },     -- notification system (disabled)
    notify = { enabled = false },        -- notifier backend

    -- == Disabled ==
    bigfile = { enabled = false },      -- big file optimization
    debug = { enabled = false },        -- debugging tools
    dim = { enabled = false },          -- dim inactive windows
    explorer = { enabled = false },     -- snacks file explorer (nvim-tree in use)
    gh = { enabled = false },           -- GitHub CLI integration
    gitbrowse = { enabled = false },    -- open GitHub pages
    git = { enabled = false },          -- git tools (blame etc.)
    health = { enabled = false },       -- health checks
    image = { enabled = false },        -- image preview in terminal
    indent = { enabled = false },       -- indent guides
    input = { enabled = false },        -- vim.ui.input styling
    lazygit = { enabled = false },      -- lazygit integration
    profiler = { enabled = false },     -- performance profiler
    quickfile = { enabled = false },    -- quick recent files
    rename = { enabled = false },       -- rename tools
    scratch = { enabled = false },      -- scratch buffers
    scroll = { enabled = false },       -- smooth scrolling
    statuscolumn = { enabled = false }, -- enhanced status column
    terminal = { enabled = false },     -- terminal integration
    toggle = { enabled = false },       -- toggle helpers
    words = { enabled = false },        -- LSP reference highlight
    zen = { enabled = false },          -- zen mode
    scope = { enabled = false },        -- buffer scopes
    keymap = { enabled = false },       -- keymap helpers
    layout = { enabled = false },       -- layout system (picker internal dep)
  })
end)
