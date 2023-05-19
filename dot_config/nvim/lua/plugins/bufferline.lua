return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local highlights = require("nord").bufferline.highlights({
			italic = false,
		})
		require("bufferline").setup({
			options = {
				separator_style = "thin",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
			highlights = highlights,
		})
	end,
	keys = {
		{ "H", "<cmd>BufferLineCyclePrev<cr>" },
		{ "L", "<cmd>BufferLineCycleNext<cr>" },
	},
	event = "VeryLazy",
}
