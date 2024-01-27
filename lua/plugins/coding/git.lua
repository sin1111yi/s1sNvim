local M = {}
local Util = require("core.util")

M = {
    {
        "lewis6991/gitsigns.nvim",
        event = { "LazyFile" },
        dependencies = {
            "petertriho/nvim-scrollbar",
            config = function()
                require("scrollbar").setup()
            end
        },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
        },
        config = function()
            require("gitsigns").setup({
                on_attach = function()
                    local gs = package.loaded.gitsigns

                    local map = require("core.util").better_nvim_keymap_set
                    -- Navigation
                    map('n', ']h', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, desc = "Next hunk" })

                    map('n', '[h', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, { expr = true, desc = "Prev hunk" })

                    -- Actions
                    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
                    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
                    map('n', '<leader>ghS', gs.stage_buffer, "Stage buffer")
                    map('n', '<leader>ghu', gs.undo_stage_hunk, "Undo stage buffer")
                    map('n', '<leader>ghR', gs.reset_buffer, "Reset buffer")
                    map('n', '<leader>ghp', gs.preview_hunk, "Preview hunk")
                    map('n', '<leader>ghb', function() gs.blame_line { full = true } end, "Blame line")
                    map('n', '<leader>ght', gs.toggle_current_line_blame, "Toggle blame (This line)")
                    map('n', '<leader>ghf', gs.diffthis, "Diff This")
                    map('n', '<leader>ghF', function() gs.diffthis('~') end, "Diff This ~")
                    map('n', '<leader>ghd', gs.toggle_deleted, "Toggle deleted")
                    map({ 'o', 'x' }, 'ghi', ':<C-U>Gitsigns select_hunk<CR>', "GitSigns Select Hunk")
                end
            })
            Util.on_load("gitsigns", function()
                require("scrollbar").setup()
                require("scrollbar.handlers.gitsigns").setup()
            end)
        end
    }
}

return M
