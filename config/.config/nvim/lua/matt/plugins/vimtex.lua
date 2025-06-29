return {
  "lervag/vimtex",
  lazy = false,     -- load immediately
  init = function()
    -- Use Skim on macOS instead of Zathura
    vim.g.vimtex_view_method       = "skim"
    vim.g.vimtex_view_skim_activate = 1   -- bring Skim to front on open
    vim.g.vimtex_view_skim_sync     = 1   -- enable forward/inverse search

    -- (optional) ensure latexmk is your compiler
    vim.g.vimtex_compiler_method   = "latexmk"
  end,
}
