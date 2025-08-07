require("dependencies").add { source = "nvim-treesitter/nvim-treesitter" }

-- TODO: test folding and incremental selection
require("nvim-treesitter.configs").setup {
  highlight = { enable = true },
  indent = { enable = true },
}
