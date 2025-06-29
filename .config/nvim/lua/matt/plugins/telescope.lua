return {
  -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  lazy = false,
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Import modules
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    local sorters = require("telescope.sorters")

    -- Configure telescope
    telescope.setup({
      defaults = {
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        file_sorter = sorters.get_fuzzy_file_sorter,
      },
      pickers = {
        find_files = {
          -- Use substring matching for exact sequence matching
          sorter = sorters.get_substr_matcher(),
        },
      },
      extensions = {
        ["ui-select"] = themes.get_dropdown(),
      },
    })

    -- Load extensions
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")

    -- Keybindings
    -- ===========

    -- Current buffer search
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(themes.get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- Search in open files
    vim.keymap.set("n", "<leader>f/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[F]ind [/] in Open Files" })

    -- Search Neovim config files
    vim.keymap.set("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[F]ind [N]eovim files" })

    -- Find files by name (with substring matching)
    vim.keymap.set("n", "<leader>ff", function()
      builtin.find_files()
    end, { desc = "[F]ind [F]iles" })

    -- Search file content with grep
    vim.keymap.set("n", "<leader>fg", function()
      builtin.live_grep()
    end, { desc = "[F]ind by [G]rep" })

    -- Find files including hidden ones
    vim.keymap.set("n", "<leader>fa", function()
      local builtin = require("telescope.builtin")
      builtin.find_files({ hidden = true })
    end, { desc = "[F]ind [A]ll files (including hidden)" })
  end,
}
