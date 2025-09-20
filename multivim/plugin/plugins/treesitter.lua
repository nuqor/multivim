require("dependencies").add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd("TSUpdate")
    end,
  },
}

config = {
  auto_install = not require("dependencies").is_nix_native(),
  highlight = { enable = true },
  -- indent = { enable = true },
}

if not require("dependencies").is_nix_native() then
  config["ensure_installed"] = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "csv",
    "dockerkfile",
    "git_config",
    "gitcommit",
    "gitignore",
    "html",
    "ini",
    "javascript",
    "json",
    "json_schema",
    "jsonc",
    "just",
    "latex",
    "make",
    "markdown",
    "markdown_inline",
    "nu",
    "python",
    "regex",
    "requirements",
    "rust",
    "scss",
    "tsv",
    "tsx",
    "typescript",
    "typst",
    "xml",
    "yaml",
  }
end

-- TODO: test folding and incremental selection
require("nvim-treesitter.configs").setup(config)
