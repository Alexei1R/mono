-- Treesitter configuration
--
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				-- Base languages from original config
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"html",

				-- Additional languages requested
				"cpp",
				"rust",
				"go",
				"python",

				-- Additional web languages
				"css",
				"typescript",
				"tsx",
				"json",
				"yaml",

				-- More programming languages
				"java",
				"kotlin",
				"ruby",
				"php",
				"bash",
				"sql",

				-- Additional useful languages
				"cmake",
				"make",
				"toml",
				"graphql",
				"regex",
				"terraform",
				"prisma",
				"zig",
				"dart",
				"hcl",

				-- General purpose
				"diff",
				"markdown",
				"markdown_inline",
				"luadoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
}
