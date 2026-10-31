require("options")
require("keymap")

-- Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- TODO: LSP
require("lazy").setup("plugins")
