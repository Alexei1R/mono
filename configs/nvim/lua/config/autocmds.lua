-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	desc = "Highlight text on yank",
	group = highlight_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Auto-resize splits when Vim window is resized
local resize_group = augroup("ResizeWindows", { clear = true })
autocmd("VimResized", {
	desc = "Resize splits when window is resized",
	group = resize_group,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})
