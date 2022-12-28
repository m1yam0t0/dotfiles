vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Package Manager
	use({
		"wbthomason/packer.nvim",
	})

	-- Package Manager for LSP
	use({
		"williamboman/mason.nvim",
		config = function()
			require("plugin-config/mason")
		end,
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
	})
	use({
		"williamboman/mason-lspconfig.nvim",
		after = {
			"mason.nvim",
			"nvim-lspconfig",
		},
		config = function()
			require("plugin-config/mason-lspconfig")
		end,
	})

	-- ColorScheme
    use({
        "shaunsingh/nord.nvim",
        config = function()
            vim.cmd[[colorscheme nord]]
        end,
    })

	-- Fuzzy Finder
	use({
		"nvim-telescope/telescope.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("plugin-config/telescope")
		end,
	})

	-- Buffer Line
	use({
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("plugin-config/bufferline")
		end,
	})

	-- Status Line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("plugin-config/lualine")
		end,
	})
end)
