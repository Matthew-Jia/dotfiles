return {
  "Pocco81/true-zen.nvim",
  cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
  config = function()
    require("true-zen").setup({
      shade       = "dark",
      backdrop    = 0.85,
      integrations = {
        tmux = true,
        kitty = { enabled = true, font = "+2" },
      },
    })
  end,
}
