require("dependencies").add { source = "mrjones2014/smart-splits.nvim" }

require("smart-splits").setup {
  at_edge = "stop",
}

vim.keymap.set(
  { "n", "t" },
  "<A-h>",
  require("smart-splits").move_cursor_left,
  { silent = true }
)

vim.keymap.set(
  { "n", "t" },
  "<A-j>",
  require("smart-splits").move_cursor_down,
  { silent = true }
)

vim.keymap.set(
  { "n", "t" },
  "<A-k>",
  require("smart-splits").move_cursor_up,
  { silent = true }
)

vim.keymap.set(
  { "n", "t" },
  "<A-l>",
  require("smart-splits").move_cursor_right,
  { silent = true }
)

vim.keymap.set(
  { "n", "t" },
  "<C-A-h>",
  require("smart-splits").resize_left,
  { silent = true }
)

vim.keymap.set(
  { "n", "t" },
  "<C-A-j>",
  require("smart-splits").resize_down,
  { silent = true }
)

vim.keymap.set(
  { "n", "t" },
  "<C-A-k>",
  require("smart-splits").resize_up,
  { silent = true }
)

vim.keymap.set(
  { "n", "t" },
  "<C-A-l>",
  require("smart-splits").resize_right,
  { silent = true }
)
