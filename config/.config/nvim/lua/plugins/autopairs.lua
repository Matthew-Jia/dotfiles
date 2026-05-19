return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        check_ts = true, -- Tells it to use Treesitter to check for context
        map_cr = true, -- Make sure this is explicitly set to true
        ts_config = {
            lua = { "string" }, -- Don't add pairs in lua string nodes
            javascript = { "template_string" },
        },
    },
    config = function(_, opts)
        local autopairs = require("nvim-autopairs")
        autopairs.setup(opts)

        -- Define your TeX rules in a reusable function
        local function setup_tex_pairs()
            -- nvim-autopairs handles generic things natively, but since you had
            -- custom manual jumps/spacing layout for TeX, we map them here:
            vim.keymap.set("i", "$", "$$<Left>", { buffer = true, silent = true })
            vim.keymap.set("i", "\\[", "\\[  \\]<Left><Left><Left>", { buffer = true, silent = true })
            vim.keymap.set("i", "\\{", "\\{  \\}<Left><Left><Left>", { buffer = true, silent = true })
        end

        -- 1. Handle files opened via the command line (Current Buffer)
        if vim.bo.filetype == "tex" then
            setup_tex_pairs()
        end

        -- 2. Handle files opened later (Autocmd)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "tex",
            callback = setup_tex_pairs,
        })
    end,
}