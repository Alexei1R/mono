return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()

		-- Basic keymaps
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():append()
		end, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle menu" })

		-- Navigation
		vim.keymap.set("n", "<C-j>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })
		vim.keymap.set("n", "<C-k>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })
		vim.keymap.set("n", "<C-l>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })
		vim.keymap.set("n", "<C-;>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })

		-- Toggle previous & next
		vim.keymap.set("n", "<C-p>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: Previous file" })
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: Next file" })
	end,
}
