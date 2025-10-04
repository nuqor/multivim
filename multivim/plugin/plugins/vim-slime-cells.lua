require("dependencies").add {
  source = "klafyvel/vim-slime-cells",
  depends = {
    "jpalardy/vim-slime",
  },
}

vim.keymap.set("n", "<C-c><C-c>", "<Plug>SlimeCellsSendAndGoToNext")
vim.keymap.set("n", "<C-c><C-j>", "<Plug>SlimeCellsNext")
vim.keymap.set("n", "<C-c><C-k>", "<Plug>SlimeCellsPrev")
