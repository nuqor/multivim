require("dependencies").add { source = "catppuccin/nvim" }

require("catppuccin").setup {
  flavour = "macchiato",
}

vim.cmd.colorscheme("catppuccin")
