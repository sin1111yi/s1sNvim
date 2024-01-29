local M = {}

M = {
    {
        "numToStr/Comment.nvim",
        event = { "BufAdd", "BufEnter", "BufNew" },
        config = function ()
            require("Comment").setup()
        end
    }

}

return M
