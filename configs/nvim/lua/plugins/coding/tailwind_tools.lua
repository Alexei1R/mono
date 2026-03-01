-- Tailwind Tools plugin
-- Unofficial Tailwind CSS integration and tooling for Neovim
return {
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			server = {
				-- tailwind-tools currently uses deprecated lspconfig setup APIs.
				-- Keep plugin features, but let main LSP config own server setup.
				override = false,
			},
		},
	},
}
