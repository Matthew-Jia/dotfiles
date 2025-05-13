-- ~/.config/nvim/lua/plugins/colorschemes.lua
return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy     = false,
    opts = {
      style            = "night",
      transparent      = false,
      terminal_colors  = true,
      day_brightness   = 0.0,
      hide_inactive_statusline = false,
      dim_inactive     = false,
      -- your other opts…
      on_highlights = function(hl, c)
        -- flat, uniform background
        hl.Normal       = { fg = c.fg,      bg = "#282A36" }
        hl.NormalFloat  = { fg = c.fg,      bg = "#282A36" }
        hl.SignColumn   = { bg = "#282A36" }
        hl.LineNr       = { fg = "#5A5A60", bg = "#282A36" }
        -- cursor line a touch lighter
        hl.CursorLine   = { bg = "#3A3A4E" }
        -- NvimTree panel
        hl.NvimTreeNormal     = { bg = "#282A36" }
        hl.NvimTreeEndOfBuffer= { fg = "#282A36", bg = "#282A36" }
        -- pop-ups & floats
        hl.FloatBorder  = { fg = "#5A5A60", bg = "#282A36" }
        hl.NormalFloat  = { bg = "#282A36" }
        -- comments greyed out
        hl.Comment      = { fg = "#5A5A60", italic = false }
        -- statusline / tabline
        hl.StatusLine   = { fg = c.blue,    bg = "#282A36" }
        hl.TabLine      = { fg = "#5A5A60", bg = "#282A36" }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight-night")
    end,
  },
}

-- return {
--   "folke/tokyonight.nvim",
--   priority = 1000,
--   init = function()
--     vim.cmd.colorscheme("tokyonight-night")
--     vim.cmd.hi("Comment gui=none")
--   end,
-- }

-- return {
--   "folke/tokyonight.nvim",
--   priority = 1000,
--   opts = {
--     -- use the purest “night” palette
--     style = "night",
--     transparent = false,
--     terminal_colors = true,
--     styles = {
--       comments = { italic = false, bold = false },
--       keywords = { italic = false },
--       functions = { bold = false },
--       variables = {},
--       sidebars = "dark", -- make help/qf floats dark
--       floats = "dark",
--     },
--     sidebars = { "qf", "help", "term" },
--     day_brightness = 0.0, -- keep it extra dark
--     hide_inactive_statusline = false,
--     dim_inactive = false,
--     lualine_bold = false,
--   },
--   config = function(_, opts)
--     -- 1) apply the colorscheme
--     require("tokyonight").setup(opts)
--     vim.cmd("colorscheme tokyonight-night")

--     -- 2) override a few groups to match the ChatGPT palette more closely
--     local hi = vim.api.nvim_set_hl
--     -- main background a touch darker
--     hi(0, "Normal", { bg = "#181818", fg = "#dcdcdc" })
--     -- floating windows / pop-ups
--     hi(0, "FloatBorder", { bg = "#1f1f27", fg = "#6a6a6a" })
--     hi(0, "NormalFloat", { bg = "#1f1f27" })
--     -- comments inlined but no italics
--     hi(0, "Comment", { fg = "#777777", italic = false })
--     -- statusline / tabline UI panels
--     hi(0, "StatusLine", { bg = "#1c1c22", fg = "#c0c0c0" })
--     hi(0, "TabLine", { bg = "#1a1a20", fg = "#8e8e8e" })
--     -- current line highlight
--     hi(0, "CursorLine", { bg = "#22222b" })
--   end,
--}

