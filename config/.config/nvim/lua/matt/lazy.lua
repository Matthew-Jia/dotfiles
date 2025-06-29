local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "matt.plugins" },
  { import = "matt.plugins.lsp" },
  { "nvim-neotest/nvim-nio" },
  { "tpope/vim-commentary" },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup()
      vim.opt.termguicolors = true

      vim.cmd([[
        highlight HopNextKey   guifg=#ff0000 gui=bold ctermfg=red cterm=bold
        highlight HopNextKey1  guifg=#ff8800 gui=bold ctermfg=208 cterm=bold
        highlight HopNextKey2  guifg=#ffff00 gui=bold ctermfg=yellow cterm=bold
        highlight HopUnmatched guifg=#444444
      ]])
    end,
  },
}, {
  install = {
    colorscheme = { "nightfly" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
