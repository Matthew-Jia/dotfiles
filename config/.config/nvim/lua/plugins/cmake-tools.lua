return {
  {
    "rcarriga/nvim-notify",
		opts = {
        stages = "fade_in_slide_out",
        timeout = 3000,
        render = "default",
		},
    config = function(_, opts)
      require("notify").setup(opts)

      vim.notify = require("notify")
    end,
  },

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {},
		keys = {
			{ "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",				desc = "Toggle floating terminal" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>",	desc = "Toggle horizontal terminal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>",		desc = "Toggle vertical terminal" },
		},
	},

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

			local opts = {
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.20 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      }

      dapui.setup(opts)

      require("nvim-dap-virtual-text").setup()

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>du", dapui.toggle)
    end,
  },

  {
    "Civitasv/cmake-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "akinsho/toggleterm.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    opts = {
      cmake_command = "cmake",
      ctest_command = "ctest",
      cmake_use_preset = true,
      cmake_regenerate_on_save = true,

      cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
      },

      cmake_build_directory = "build/${variant:buildType}",

      cmake_executor = {
        name = "toggleterm",
        opts = {
          direction = "float",
          close_on_exit = false,
          auto_scroll = true,
          singleton = true,
        },
      },

      cmake_runner = {
        name = "toggleterm",
        opts = {
          direction = "float",
          close_on_exit = false,
          auto_scroll = true,
          singleton = true,
        },
      },

      cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        refresh_rate_ms = 100,
      },

      cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
      },
    },
	},
}
