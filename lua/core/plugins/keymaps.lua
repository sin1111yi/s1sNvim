local Util = require("core.util")

local _map = {}

local vmap = Util.better_nvim_keymap_set
local smap = Util.safe_keymap_set

_map.tb = {
    ["leader"] = {
        b = {
            name = "+Buffer",
            d = { "<cmd>lua require('core.plugins.exapi').buf_del.del_current()<cr>", "Delete current" },
            o = { "<cmd>lua require('core.plugins.exapi').buf_del.del_others()<cr>", "Delete others" },
            l = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('left')<cr>", "Delete left" },
            h = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('right')<cr>", "Delete right" },
            b = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('all')<cr>", "Delete all" },
            e = {
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                "Explorer buffers",
            },
            s = { "<cmd>ls<cr>", "List all" },
        },

        c = {
            name = "+Code",
            f = { "<cmd>FormatWrite<cr>", "Format buffer" },
            d = { "<cmd>AerialToggle<cr>", "Toggle code outline" },
            g = { "<cmd>AerialNavToggle<cr>", "Toggle code navigate" }
        },

        f = {
            name = "+File",
            e = {
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
                end,
                "Explorer root dir",
            },
            E = {
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                "Explorer cwd",
            },
        },

        g = {
            name = "+Git",
            e = {
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                "Git explorer",
            },
            h = {
                name = "+Gitsigns"
            },
        },

        p = {
            name = "+Plugins",
            l = { "<cmd>Lazy<cr>", "Lazy" },
            m = { "<cmd>Mason<cr>", "Mason" },
            u = { "<cmd>UpdateAll<cr>", "Update all" },
            d = { "<cmd>Dashboard<cr>", "Show dashboard" }
        },

        s = {
            name = "+Search & Session",
            r = {
                function()
                    require("spectre").open()
                end,
                "Replace in files",
            },
            s = {
                function()
                    require("persistence").load()
                end,
                "Restore Session"
            },
            l = {
                function()
                    require("persistence").load({ last = true })
                end,
                "Restore Last Session" },
            d = {
                function()
                    require("persistence").stop()
                end,
                "Don't Save Current Session" },
        },

        x = {
            name = "+Trouble",
            x = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
            X = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
            q = { "<cmd>TroubleToggle loclist<cr>", "Document Location List" },
            Q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List" },
        }
    },
}

_map.opts = {
    ["leader"] = { prefix = "<leader>" },
}

vmap("n", "<leader>e", "<leader>fe", { desc = "Explorer root dir" })
vmap("n", "<leader>E", "<leader>fE", { desc = "Explorer cwd" })

require("which-key").register(_map.tb["leader"], _map.opts["leader"])

if Util.has("neoscorll.nvim") then
    local _neoscorll_keymap = {
        ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
        ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } },
        ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "450" } },
        ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "450" } },
        ["<C-y>"] = { "scroll", { "-0.10", "false", "100" } },
        ["<C-e>"] = { "scroll", { "0.10", "false", "100" } },
        ["zt"] = { "zt", { "250" } },
        ["zz"] = { "zz", { "250" } },
        ["zb"] = { "zb", { "250" } },
    }

    require("neoscroll.config").set_mappings(_neoscorll_keymap)
else
    smap("n", "<c-u>", "10k", { desc = "Scroll up" })
    smap("n", "<c-d>", "10j", { desc = "Scroll up" })
end

if Util.has("gitsigns.nvim") then
    require("gitsigns").setup({
        on_attach = function()
            local gs = package.loaded.gitsigns

            -- Navigation
            vmap("n", "]h", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "Next hunk" })

            vmap("n", "[h", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "Prev hunk" })

            -- Actions
            vmap({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
            vmap({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
            vmap("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
            vmap("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage buffer")
            vmap("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
            vmap("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
            vmap("n", "<leader>ghb", function() gs.blame_line { full = true } end, "Blame line")
            vmap("n", "<leader>ght", gs.toggle_current_line_blame, "Toggle blame (This line)")
            vmap("n", "<leader>ghf", gs.diffthis, "Diff This")
            vmap("n", "<leader>ghF", function() gs.diffthis("~") end, "Diff This ~")
            vmap("n", "<leader>ghd", gs.toggle_deleted, "Toggle deleted")
            vmap({ "o", "x" }, "ghi", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        end
    })
end

if Util.has("glance.nvim") then
    vmap("n", "gS", "<cmd>Glance definitions<cr>", "Browse definitions")
    vmap("n", "gR", "<cmd>Glance references<cr>", "Browse references")
    vmap("n", "gY", "<cmd>Glance type_definitions<cr>", "Browse type definitions")
    vmap("n", "gM", "<cmd>Glance implementations<cr>", "Browse implementations")
end
