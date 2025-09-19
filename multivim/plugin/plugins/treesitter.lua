require("dependencies").add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd("TSUpdate")
    end,
  },
}

-- TODO: test folding and incremental selection
require("nvim-treesitter.configs").setup {
  auto_install = not require("dependencies").is_nix_native(),
  highlight = { enable = true },
  -- indent = { enable = true },
}
