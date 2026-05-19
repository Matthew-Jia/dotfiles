return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                args = { "--port", "${port}" },
            },
        }

        -- Make DAP's integrated terminal open like the cmake-tools terminal
        dap.defaults.fallback.terminal_win_cmd = "belowright 11split new"
    end,
}