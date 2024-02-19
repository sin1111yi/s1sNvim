local M = {}

M = {
    {
        "echasnovski/mini.comment",
        event = { "BufAdd", "BufEnter", "BufNew" },
        config = function()
            require("mini.comment").setup()
        end
    }

}

return M
