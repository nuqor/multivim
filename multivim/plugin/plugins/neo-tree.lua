require("dependencies").add {
  source = "nvim-neo-tree/neo-tree.nvim",
  depends = {
    "MunifTanjim/nui.nvim",
    "folke/noice.nvim",
    "nvim-lua/plenary.nvim",
  },
}

require("neo-tree").setup {
  filesystem = {
    filtered_items = {
      always_show = { ".gitignored" },
      never_show = { ".DS_Store" },
    },
  },
}

vim.keymap.set(
  "n",
  "<C-b>",
  "<Cmd>Neotree filesystem reveal left<CR>",
  { silent = true }
)
