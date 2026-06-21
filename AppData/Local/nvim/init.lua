local opt = vim.opt

opt.number = true
opt.background = "dark"

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.showmatch = true

opt.termguicolors = true

vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", ":", ";")
vim.keymap.set("n", ";", ":")
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
