return {
  "vim-scripts/ReplaceWithRegister",
  config = function()
    -- Disable default mappings to avoid conflicts
    vim.g.ReplaceWithRegisterMap = 0

    -- Set custom mappings
    vim.keymap.set('n', '<leader>r', '<Plug>ReplaceWithRegisterOperator', { desc = 'Replace with register operator' })
    vim.keymap.set('n', '<leader>rr', '<Plug>ReplaceWithRegisterLine', { desc = 'Replace line with register' })
  end,
}
