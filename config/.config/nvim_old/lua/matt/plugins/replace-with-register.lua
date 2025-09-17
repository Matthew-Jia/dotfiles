return {
  "vim-scripts/ReplaceWithRegister",
  init = function()
    vim.keymap.set("n", "<leader>p",  "<Plug>ReplaceWithRegisterOperator", { desc = "Replace with register (operator)", remap = true })
		vim.keymap.set("n", "<leader>pp", "<Plug>ReplaceWithRegisterLine", { desc = "Replace line with register",     remap = true })
    vim.keymap.set("x", "<leader>p",  "<Plug>ReplaceWithRegisterVisual", { desc = "Replace selection with register", remap = true })

  end,
}
