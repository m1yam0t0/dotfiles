return {
	"nvim-telescope/telescope.nvim",
	dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        {"<leader>f", "<cmd>Telescope find_files<cr>"},
        {"<leader>g", "<cmd>Telescope live_grep<cr>"},
        {"<leader>b", "<cmd>Telescope buffers<cr>"},
        {"<leader>c", "<cmd>Telescope commands<cr>"},
        {"<leader>h", "<cmb>Telescope help_tags<cr>" },
    }
}
