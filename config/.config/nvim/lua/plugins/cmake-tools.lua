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
		lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
			local dapui_vt = require("nvim-dap-virtual-text")

			local dapui_opts = {
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

			local dapui_vt_opts = {}

      dapui.setup(dapui_opts)
      dapui_vt.setup(dapui_vt_opts)

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

			vim.keymap.set("n", "<leader>ds", function()
				if dap.session() then
					dap.continue()
				else
					vim.cmd("CMakeDebug")
				end
			end, { desc = "dap start/continue" })

			vim.keymap.set("n", "<leader>dt", function()
				dap.terminate()
				dapui.close()
			end, { desc = "DAP terminate" })

			vim.keymap.set("n", "<leader>dr", dap.restart_frame, { desc = "DAP restart frame" })
			vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "DAP continue to cursor" })
			vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "DAP step over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
			vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP step out" })
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP conditional breakpoint" })
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
		opts = function ()
			local osys = require("cmake-tools.osys");

			return {
				cmake_command = "cmake", -- this is used to specify cmake command path
				ctest_command = "ctest", -- this is used to specify ctest command path
				ctest_show_labels = false, -- also show labels in the test picker
				cmake_use_preset = true,
				cmake_regenerate_on_save = false, -- auto generate when save CMakeLists.txt
				cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
				cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
				-- support macro expansion:
				--       ${kit}
				--       ${kitGenerator}
				--       ${variant:xx}
				cmake_build_directory = function()
					if osys.iswin32 then
						return "out\\${variant:buildType}"
					end
					return "out/${variant:buildType}"
				end, -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
				cmake_compile_commands_options = {
					action = "soft_link", -- available options: soft_link, copy, lsp, none
					-- soft_link: this will automatically make a soft link from compile commands file to target
					-- copy:      this will automatically copy compile commands file to target
					-- lsp:       this will automatically set compile commands file location using lsp
					-- none:      this will make this option ignored
					target = vim.loop.cwd, -- path or function returning path to directory, this is used only if action == "soft_link" or action == "copy"
				},
				cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
				cmake_variants_message = {
					short = { show = true }, -- whether to show short message
					long = { show = true, max_length = 40 }, -- whether to show long message
				},
				cmake_dap_configuration = { -- debug settings for cmake
					name = "cpp",
					type = "codelldb",
					request = "launch",
					stopOnEntry = false,
					runInTerminal = true,
					console = "integratedTerminal",
				},

				cmake_executor = {
					name = "quickfix",
					opts = {
						show = "only_on_error",
						position = "belowright",
						size = 10,
						encoding = "utf-8",
						auto_close_when_success = true,
					},
				},

				cmake_runner = {
					name = "terminal",
					opts = {
						name = "CMake Run",
						prefix_name = "[CMakeRun]: ",
						split_direction = "belowright",
						split_size = 12,

						start_insert = false,
						focus = false,
						do_not_add_newline = false,

						single_terminal_per_instance = true,
						single_terminal_per_tab = true,
						keep_terminal_static_location = true,
						auto_resize = true,
					},
				},

				cmake_notifications = {
					runner = { enabled = false },
					executor = { enabled = true },
					spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
					refresh_rate_ms = 100, -- how often to iterate icons
				},
				cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
				cmake_use_scratch_buffer = false, -- A buffer that shows what cmake-tools has done
			}
		end,
	},
}
