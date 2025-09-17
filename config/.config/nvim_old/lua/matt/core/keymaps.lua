-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- General Keymaps --
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grn")

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- line wrap --
keymap.set("n", "<leader>tw", "<cmd>set wrap! linebreak!<CR>", { desc = "Toggle soft wrap" })
keymap.set("n", "j", "gj", { desc = "Down by screen line" })
keymap.set("n", "k", "gk", { desc = "Up by screen line" })
keymap.set("n", "^", '(&wrap ? "g^" : "^")', { expr = true, silent = true, desc = "Smart ^ (screen or real line)" })
keymap.set("n", "$", '(&wrap ? "g$" : "$")', { expr = true, silent = true, desc = "Smart $ (screen or real line)" })
keymap.set("v", "j", "gj", { desc = "Visual down by screen line" })
keymap.set("v", "k", "gk", { desc = "Visual up by screen line" })
keymap.set("v", "^", '(&wrap ? "g^" : "^")', { expr = true, silent = true, desc = "Smart visual ^" })
keymap.set("v", "$", '(&wrap ? "g$" : "$")', { expr = true, silent = true, desc = "Smart visual $" })

-- toggle tab width -- 
vim.keymap.set("n", "<leader>tt", function()
  local ts = vim.bo.tabstop          -- current width
  local new = (ts == 4) and 2 or 4   -- flip 4→2 or 2→4
  vim.bo.tabstop     = new
  vim.bo.shiftwidth  = new
  vim.bo.softtabstop = new
  vim.notify("Tab width set to " .. new)
end, { desc = "Toggle tab width 2↔4" })
