require("dependencies").add {
  source = "nvim-neo-tree/neo-tree.nvim",
  depends = {
    "MunifTanjim/nui.nvim",
    "folke/noice.nvim",
    "nvim-lua/plenary.nvim",
  },
}

require("neo-tree").setup {
  close_if_last_window = true,
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      always_show = { ".gitignored" },
      never_show = {
        ".DS_Store",
        ".git",
      },
    },
    follow_current_file = {
      enabled = true,
    },
  },
  window = {
    mappings = {
      ["<C-b>"] = "close_window",
    },
  },
}

vim.keymap.set(
  "n",
  "<C-b>",
  "<Cmd>Neotree filesystem toggle left<CR>",
  { silent = true }
)
