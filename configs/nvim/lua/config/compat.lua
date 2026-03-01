-- Compatibility shims for plugin APIs against newer Neovim versions.

local lsp_util = vim.lsp and vim.lsp.util
if lsp_util and type(lsp_util.show_document) == "function" then
	lsp_util.jump_to_location = function(location, offset_encoding, reuse_win)
		return lsp_util.show_document(location, offset_encoding, {
			focus = true,
			reuse_win = reuse_win ~= false,
		})
	end
end
