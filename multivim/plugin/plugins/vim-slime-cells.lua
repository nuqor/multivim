require("dependencies").add {
  source = "klafyvel/vim-slime-cells",
  checkout = "main",
  depends = {
    "jpalardy/vim-slime",
  },
}

vim.g.cells_highlight_from = "Comment"

vim.keymap.set("n", "<C-c><C-c>", "<Plug>SlimeCellsSend")
vim.keymap.set("n", "<C-c><C-j>", "<Plug>SlimeCellsNext")
vim.keymap.set("n", "<C-c><C-k>", "<Plug>SlimeCellsPrev")
