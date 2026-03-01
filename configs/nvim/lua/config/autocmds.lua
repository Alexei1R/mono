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

-- Format on save using conform.nvim
local format_group = augroup("FormatOnSave", { clear = true })
autocmd("BufWritePre", {
	desc = "Format buffer before saving",
	group = format_group,
	callback = function(args)
		if not vim.g.autoformat then
			return
		end

		local ok, conform = pcall(require, "conform")
		if not ok then
			return
		end

		conform.format({
			bufnr = args.buf,
			timeout_ms = 500,
			lsp_format = "fallback",
		})

		-- message notification
		vim.notify("Formatted buffer " .. args.buf, vim.log.levels.INFO, {
			title = "Autoformat",
			timeout = 1000,
		})

	end,
})
