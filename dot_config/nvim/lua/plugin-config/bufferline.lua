require("bufferline").setup({
	options = {
		indicator = {
			style = "none",
		},
		show_buffer_close_icons = false,
		show_close_icon = false,
	},
	highlights = {
		buffer_selected = {
			italic = false,
		},
	},
})

vim.keymap.set("n", "H", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
vim.keymap.set("n", "L", "<Cmd>BufferLineCycleNext<CR>", { silent = true })
