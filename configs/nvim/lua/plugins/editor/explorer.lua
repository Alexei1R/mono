-- Oil file explorer configuration
return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>e",
				function()
					require("oil").toggle_float()
				end,
				desc = "Open Oil file explorer (float)",
			},
		},
		opts = {
			default_file_explorer = true,
			columns = {
				"icon",
				-- "permissions",
				-- "size",
				-- "mtime",
			},
			float = {
				padding = 2,
				-- max_width = 80,
				-- max_height = 30,
			},
			keymaps = {
				["<C-h>"] = false, -- Disable to allow window navigation
				["<C-l>"] = false, -- Disable to allow window navigation
			},
			use_default_keymaps = true,
			view_options = {
				show_hidden = true,
			},
		},
	},

	-- plugins/nvim-tree.lua
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		keys = {
			{ "<leader>t", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
		},
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 45,
					side = "right",
				},
				renderer = { group_empty = true },
				filters = { dotfiles = false },
				git = { enable = true },
			})
		end,
	},
}
