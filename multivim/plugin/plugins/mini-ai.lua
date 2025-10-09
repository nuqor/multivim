require("dependencies").add {
  source = "nvim-mini/mini.ai",
  depends = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}

local spec_treesitter = require("mini.ai").gen_spec.treesitter

require("mini.ai").setup {
  custom_textobjects = {
    F = spec_treesitter { a = "@function.outer", i = "@function.inner" },
    o = spec_treesitter {
      a = { "@conditional.outer", "@loop.outer" },
      i = { "@conditional.inner", "@loop.inner" },
    },
    C = spec_treesitter { a = { "@class.outer" }, i = { "@class.inner" } },
  },
}
