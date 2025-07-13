local map = {
	{ "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })) end, desc = "[/]  Search in current buffer" },
	{ "<leader>f/", function() require("telescope.builtin").live_grep({grep_open_files = true, prompt_title = "Live Grep in Open Files",})end, desc = "[F]ind [/] in open files" },
	{ "<leader>fd", function() require("telescope.builtin").find_files({ cwd = "~/dotfiles", hidden = true }) end, desc = "[F]ind [D]otfiles" },
	{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "[F]ind [F]iles" },
	{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "[F]ind by [G]rep" },
	{ "<leader>fa", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "[F]ind [A]ll files (incl. hidden)" },
	{ "gr", function() require("telescope.builtin").lsp_references() end, desc = "[G]o to [R]eferences" },
	{ "gd", function() require("telescope.builtin").lsp_definitions() end, desc = "[G]o to [D]efinition" },
	{ "gi", function() require("telescope.builtin").lsp_implementations() end, desc = "[G]o to [I]mplementation" },
	{ "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "[F]ind [S]ymbols in document" },
	{ "<leader>fS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "[F]ind [S]ymbols in workspace" },
}

return {
  -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
  lazy = false,
  event = "VimEnter",
	keys = map,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-tree/nvim-web-devicons" },
  },

  config = function()
    -- Import modules
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    local sorters = require("telescope.sorters")
    local defaults = require("telescope.config").values

    -- Configure telescope
    telescope.setup({
      defaults = {
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        file_sorter = sorters.get_fuzzy_file_sorter,
        path_display = { 'smart' },
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
  end,
}
