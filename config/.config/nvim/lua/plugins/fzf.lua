return {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    keys = function()
        local fzf = require("fzf-lua")
        return {
            { "<leader>ff", function() fzf.files({ hidden = false }) end, desc = "[F]ind [F]iles", },
            { "<leader>fa", function() fzf.files() end, desc = "[F]ind [A]ll files", },
            { "<leader>fd", function() fzf.files({ cwd = "~/dotfiles", hidden = true }) end, desc = "[F]ind [D]otfiles", },
            { "<leader>fg", function() fzf.live_grep() end, desc = "[F]ind by [G]rep", },
            { "<leader>/", function() fzf.blines() end, desc = "[/] Search in buffer" },
            { "gd", function() fzf.lsp_definitions() end, desc = "Go to [D]efinition" },
            { "gr", function() fzf.lsp_references() end, desc = "Go to [R]eferences" },
            { "gi", function() fzf.lsp_implementations() end, desc = "Go to [I]mplementation" },
        }
    end,
    opts = {},
}