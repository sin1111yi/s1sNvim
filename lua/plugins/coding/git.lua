local M = {}

local vmap = function(mode, lhs, rhs, opts)
    opts = vim.tbl_deep_extend("force", { remap = true, silent = true }, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
end

M = {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufAdd", "BufNew", "BufEnter" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local map = function(mode, l, r, opts)
                    local _opts = { buffer = bufnr }
                    if type(opts) == "string" then
                        _opts.desc = opts
                    else
                        _opts = vim.tbl_deep_extend("force", _opts, opts)
                    end
                    vmap(mode, l, r, _opts)
                end

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
                map('n', '<leader>ghS', gs.stage_buffer, "Stage buffer" )
                map('n', '<leader>ghu', gs.undo_stage_hunk, "Undo stage buffer" )
                map('n', '<leader>ghR', gs.reset_buffer,  "Reset buffer" )
                map('n', '<leader>ghp', gs.preview_hunk,  "Preview hunk" )
                map('n', '<leader>ghb', function() gs.blame_line { full = true } end,  "Blame line" )
                map('n', '<leader>ght', gs.toggle_current_line_blame,  "Toggle blame (This line)" )
                map('n', '<leader>ghf', gs.diffthis,  "Diff This" )
                map('n', '<leader>ghF', function() gs.diffthis('~') end,  "Diff This ~" )
                map('n', '<leader>ghd', gs.toggle_deleted,  "Toggle deleted" )
                map({ 'o', 'x' }, 'ghi', ':<C-U>Gitsigns select_hunk<CR>',  "GitSigns Select Hunk" )
            end
        },
    }
}

return M
