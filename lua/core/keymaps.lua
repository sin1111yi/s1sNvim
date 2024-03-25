local M = {}

local Util = require("core.util")

local vmap = Util.better_nvim_keymap_set
local smap = Util.safe_keymap_set

-- Move to window using the <ctrl> hjkl keys
smap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
smap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
smap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
smap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
smap("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
smap("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
smap("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
smap("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
smap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
smap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
smap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
smap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
smap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
smap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
if Util.has("bufferline.nvim") then
    smap("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    smap("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    smap("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    smap("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
    smap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    smap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    smap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    smap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

-- Clear search with <esc>
smap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
smap("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
smap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
smap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
smap("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
smap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
smap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- windows
smap("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
smap("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
smap("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
smap("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
smap("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
smap("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
smap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
smap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
smap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
smap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
smap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
smap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

smap("t", "<esc>", "<c-\\><c-n>", { desc = "Escape terminal insert" })

require("which-key").register({
    q = {
        name = "+Quit",
        c = { "<cmd>q<cr>", "Quit" },
        w = { "<cmd>wq<cr>", "Save & Quit" },
        a = { "<cmd>qa<cr>", "Quit all" },
        q = { "<cmd>wqa<cr>", "Save & Quit all" },
    },

    r = {
        name = "+Built-in",
        n = {
            function()
                if vim.o.relativenumber == true then
                    vim.cmd("set norelativenumber")
                else
                    vim.cmd("set relativenumber")
                end
                Util.info("Toggle relativenumber")
            end, "Toggle relativenumber"
        }
    },

    t = {
        name = "+Terminal",
        t = { "<cmd>split | terminal<cr>", "Open terminal" }
    },

    w = {
        name = "+Window"
    }
}, { prefix = "<leader>" })

require("core.plugins.keymaps")

return M
