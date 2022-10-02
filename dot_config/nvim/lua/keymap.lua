vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", ":", ";")
vim.keymap.set("n", ";", ":")
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
