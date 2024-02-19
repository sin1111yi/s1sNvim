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
        },

        s = {
            name = "+Search",
            l = { "<cmd>Legendary<cr>", "Legendary" },
            r = {
                function()
                    require("spectre").open()
                end,
                "Replace in files",
            },
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

require("gitsigns").setup({
    on_attach = function()
        local gs = package.loaded.gitsigns

        local map = require("core.util").better_nvim_keymap_set
        -- Navigation
        map("n", "]h", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        map("n", "[h", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
        end, { expr = true, desc = "Prev hunk" })

        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>ghb", function() gs.blame_line { full = true } end, "Blame line")
        map("n", "<leader>ght", gs.toggle_current_line_blame, "Toggle blame (This line)")
        map("n", "<leader>ghf", gs.diffthis, "Diff This")
        map("n", "<leader>ghF", function() gs.diffthis("~") end, "Diff This ~")
        map("n", "<leader>ghd", gs.toggle_deleted, "Toggle deleted")
        map({ "o", "x" }, "ghi", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end
})
