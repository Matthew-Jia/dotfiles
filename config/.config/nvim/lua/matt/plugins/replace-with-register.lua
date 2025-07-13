return {
  "vim-scripts/ReplaceWithRegister",
  init = function()
    vim.keymap.set("n", "R",  "<Plug>ReplaceWithRegisterOperator", { desc = "Replace with register (operator)", remap = true })
		vim.keymap.set("n", "RR", "<Plug>ReplaceWithRegisterLine", { desc = "Replace line with register",     remap = true })
    vim.keymap.set("x", "R",  "<Plug>ReplaceWithRegisterVisual", { desc = "Replace selection with register", remap = true })
  end,
}
