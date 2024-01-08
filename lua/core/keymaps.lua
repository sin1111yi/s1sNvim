local M = {}

local utils = require("core.utils")
local wk = require("which-key")

local vmap = vim.keymap.set
local smap = utils.safe_keymap_set

local keyopts = { noremap = true, silent = true }

-- Move to window using the <ctrl> hjkl keys
vmap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vmap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vmap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vmap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

wk.register({
    e = {"<cmd>Neotree toggle<cr>", "Neo Tree Toggle"},
    x = {
        name = "+Extra",
        n = {
            function()
                require("core.utils").say_hi()
            end, "Notify Test" }
    }
}, { prefix = "<leader>" })

return M
