-- Core keymaps independent of plugins
local map = vim.keymap.set

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>z", "<cmd>wq<cr>", { desc = "Save and quit" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word under cursor" })
map("n", "U", "<C-r>", { desc = "Redo" })

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Terminal navigation
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Terminal: move to left window" })
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Terminal: move to bottom window" })
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Terminal: move to top window" })
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Terminal: move to right window" })

-- LSP related
map("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "Open diagnostics in float" })

map("n", "<leader>cf", function()
  require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format current file" })

-- Center buffer while navigating
local navigation_mappings = {
  ["<C-u>"] = "<C-u>zz",
  ["<C-d>"] = "<C-d>zz",
  ["{"] = "{zz",
  ["}"] = "}zz",
  ["N"] = "Nzz",
  ["n"] = "nzz",
  ["G"] = "Gzz",
  ["gg"] = "ggzz",
  ["<C-i>"] = "<C-i>zz",
  ["<C-o>"] = "<C-o>zz",
  ["%"] = "%zz",
  ["*"] = "*zz",
  ["#"] = "#zz",
}

for key, cmd in pairs(navigation_mappings) do
  map("n", key, cmd, { desc = "Centered " .. key })
end

-- Reserved leader mappings (defined by plugins but listed here for documentation)
-- <leader>e - Oil file explorer
