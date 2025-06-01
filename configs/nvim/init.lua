-- Kickstart-inspired Neovim configuration
-- Minimal entrypoint that delegates to modules

-- Set <space> as leader key (must happen before plugins are loaded)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set flag for nerd font detection
vim.g.have_nerd_font = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require("config.keymaps")
require("config.autocmds")
require("config.options")

-- Load plugins
require("lazy").setup({
	-- Import all plugin specs from lua/plugins directories
	{ import = "plugins" },
	{ import = "plugins.ui" },
	{ import = "plugins.editor" },
	{ import = "plugins.coding" },
	{ import = "plugins.lsp" },
}, {
	ui = {
		-- Use nerd font icons if available, otherwise use unicode
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
