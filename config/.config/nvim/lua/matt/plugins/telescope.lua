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
    vim.keymap.set("n", "<leader>/", function() builtin.current_buffer_fuzzy_find(themes.get_dropdown({ winblend = 10, previewer = false, })) end, { desc = "[/] Fuzzily search in current buffer" })
    vim.keymap.set("n", "<leader>f/", function() builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files", }) end, { desc = "[F]ind [/] in Open Files" })
    vim.keymap.set("n", "<leader>fd", function() builtin.find_files({ cwd = "~/dotfiles", hidden = true }) end, { desc = "[F]ind [D]otfiles" })
    vim.keymap.set("n", "<leader>ff", function() builtin.find_files() end, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fg", function() builtin.live_grep() end, { desc = "[F]ind by [G]rep" })
    vim.keymap.set("n", "<leader>fa", function() builtin.find_files({ hidden = true }) end, { desc = "[F]ind [A]ll files (including hidden)" })
    vim.keymap.set("n", "gr", function() builtin.lsp_references() end, { desc = "[G]o to [R]eferences" })
    vim.keymap.set("n", "gd", function() builtin.lsp_definitions() end, { desc = "[G]o to [D]efinition" })
    vim.keymap.set("n", "gi", function() builtin.lsp_implementations() end, { desc = "[G]o to [I]mplementation" })
    vim.keymap.set("n", "<leader>fs", function() builtin.lsp_document_symbols() end, { desc = "[F]ind [S]ymbols in document" })
    vim.keymap.set("n", "<leader>fS", function() builtin.lsp_workspace_symbols() end, { desc = "[F]ind [S]ymbols in workspace" })

    -- Current buffer search
  end,
}
