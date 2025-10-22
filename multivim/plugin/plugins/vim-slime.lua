require("dependencies").add {
  source = "jpalardy/vim-slime",
  checkout = "main",
}

vim.g.slime_cell_delimiter = "^#\\s*%%"
vim.g.slime_no_mappings = 1
vim.g.slime_target = "wezterm"
vim.g.slime_bracketed_paste = 1
