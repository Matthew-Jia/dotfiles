return {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {},
    keys = {
        { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",				desc = "Toggle floating terminal" },
        { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>",	desc = "Toggle horizontal terminal" },
        { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>",		desc = "Toggle vertical terminal" },
    },
}