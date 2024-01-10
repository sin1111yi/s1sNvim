local M = {}

local utils = require("core.utils")
local wk = require("which-key")

local vmap = vim.keymap.set
local smap = utils.safe_keymap_set

local keyopts = { remap = true, silent = true }

-- Move to window using the <ctrl> hjkl keys
smap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
smap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
smap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
smap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

wk.register({
    e = { "<cmd>Neotree toggle<cr>", "Neo Tree Toggle" },

    x = {
        name = "+Extra",
        n = {
            function()
                require("core.utils").say_hi()
            end, "Notify Test" }
    }
}, { prefix = "<leader>" })

return M
