-- Treesitter configuration
--
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- Keep your full language set, but do not auto-install on startup.
			local languages = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"html",
				"cpp",
				"rust",
				"go",
				"python",
				"css",
				"typescript",
				"tsx",
				"json",
				"yaml",
				"java",
				"kotlin",
				"ruby",
				"php",
				"bash",
				"sql",
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
				"glsl",
				"wgsl",
				"diff",
				"markdown",
				"markdown_inline",
				"luadoc",
			}
			local wgsl_parser_candidates = { "wgsl", "wgsl_bevy" }

			vim.api.nvim_create_user_command("TSInstallConfigured", function()
				require("nvim-treesitter").install(languages)
			end, { desc = "Install configured treesitter parsers" })

			-- Ensure WGSL highlighting works even when parsers were never preinstalled.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "wgsl",
				callback = function(event)
					for _, lang in ipairs(wgsl_parser_candidates) do
						if pcall(vim.treesitter.language.add, lang) then
							pcall(vim.treesitter.start, event.buf, lang)
							return
						end
					end

					for _, lang in ipairs(wgsl_parser_candidates) do
						pcall(require("nvim-treesitter").install, { lang })
					end
					pcall(vim.treesitter.start, event.buf, "wgsl")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
}
