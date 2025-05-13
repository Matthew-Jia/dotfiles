-- return {
--   -- Make sure the plugin is lazy-loaded or not, depending on your preference
--   "folke/tokyonight.nvim",
--   lazy = false, -- load it immediately
--   priority = 1000, -- load this before other plugins so the colors apply correctly
--   config = function()
--     require("tokyonight").setup({
--       style = "moon", -- "night", "storm", "moon", or "day"
--       transparent = false, -- set to true if you want a transparent background
--       terminal_colors = true, -- apply the theme’s colors to :terminal
--       styles = {
--         comments = { italic = false },
--         keywords = { italic = false },
--         functions = {},
--         variables = {},
--       },
--       sidebars = { "qf", "help", "terminal", "packer" },
--       on_highlights = function(hl, c)
--         -- You can tweak individual highlight groups here if needed.
--         -- For example:
--         -- hl.LineNr = { fg = c.dark5 }
--       end,
--     })
--     vim.cmd([[colorscheme tokyonight]])
--   end,
-- }

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

return {
  -- lush is required by nvim-snazzy
  { "rktjmp/lush.nvim", lazy = false },

  -- the actual Snazzy theme
  {
    "alexwu/nvim-snazzy",
    lazy = false,           -- load immediately
    priority = 10000,        -- load before other plugins
    dependencies = { "rktjmp/lush.nvim" },
    colorscheme = "snazzy", -- <--- this line applies the scheme
  },
}
