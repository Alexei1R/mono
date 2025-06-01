-- Indentation settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true

-- Line numbers with minimal styling
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2 -- Set to 2 columns for line numbers

-- Layout settings
vim.opt.foldcolumn = "0"
vim.opt.signcolumn = "yes"

-- UI settings
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.scrolloff = 8
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.wrap = false

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- Whitespace display
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Editor behavior
vim.opt.undofile = true
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.updatetime = 250
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Folding settings
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nerd Font
vim.g.have_nerd_font = true

vim.o.title = false

vim.o.showtabline = 0

vim.g.neovide_hide_titlebar = true

vim.o.laststatus = 0
vim.o.cmdheight = 0

vim.opt.showtabline = 0
vim.opt.laststatus = 0
vim.opt.cmdheight = 0

-- Create hook to remove line number highlighting after color scheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- Remove all highlighting from line numbers
		vim.cmd("highlight clear LineNr")
		vim.cmd("highlight clear CursorLineNr")
		vim.cmd("highlight clear SignColumn")
	end,
})
