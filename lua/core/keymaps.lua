local M = {}

local wk = require("which-key")

local utils = require("core.utils")

local vmap = vim.keymap.set
local smap = utils.safe_keymap_set

local keyopts = { noremap = true, silent = true }

smap("n", "<c-x>", "<cmd>lua require('core.utils').say_hi()<cr>", keyopts)

M.defaults_keymap = {

}

return M
