require("dependencies").add {
  source = "nvim-treesitter/nvim-treesitter-textobjects",
  depends = {
    "nvim-treesitter/nvim-treesitter",
  },
}

--
-- mini.ai
--

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

--
-- mini.bracketed
--

require("mini.bracketed").setup()

--
-- mini.files
--

require("mini.files").setup()

vim.keymap.set("n", "-", require("mini.files").open)

--
-- mini.icons
--

require("mini.icons").setup {
  extension = {
    ["lock"] = { glyph = "󰌾 " },
  },
  file = {
    ["README.md"] = { glyph = " " },
  },
}

MiniIcons.mock_nvim_web_devicons()

--
-- mini.pairs
--

require("mini.pairs").setup()

--
-- mini.starter
--

require("mini.starter").setup {
  header = [[
███╗   ███╗██╗   ██╗██╗  ████████╗██╗██╗   ██╗██╗███╗   ███╗
████╗ ████║██║   ██║██║  ╚══██╔══╝██║██║   ██║██║████╗ ████║
██╔████╔██║██║   ██║██║     ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╔╝██║██║   ██║██║     ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
  ]],
  items = {
    require("mini.starter").sections.recent_files(5, true, false),
    require("mini.starter").sections.recent_files(5, false, true),
    require("mini.starter").sections.builtin_actions(),
  },
  footer = function()
    local version = vim.version()
    return "Neovim "
      .. version.major
      .. "."
      .. version.minor
      .. "."
      .. version.patch
  end,
  content_hooks = {
    require("mini.starter").gen_hook.adding_bullet(" ", false),
    require("mini.starter").gen_hook.aligning("center", "center"),
  },
}

--
-- mini.statusline
--

vim.api.nvim_set_hl(0, "StatusLineMode", {
  fg = require("catppuccin.palettes").get_palette().peach,
})

vim.api.nvim_create_autocmd(
  { "ModeChanged", "RecordingEnter", "RecordingLeave" },
  {
    pattern = "*",
    callback = function()
      vim.cmd("redrawstatus")
    end,
  }
)

require("mini.statusline").setup {
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode {
        trunc_width = 120,
      }
      local git = MiniStatusline.section_git {
        trunc_width = 40,
      }
      local diagnostics = MiniStatusline.section_diagnostics {
        trunc_width = 75,
      }
      local filename = MiniStatusline.section_filename {
        trunc_width = 140,
      }
      local fileinfo = MiniStatusline.section_fileinfo {
        trunc_width = 120,
      }
      local search = MiniStatusline.section_searchcount {
        trunc_width = 75,
      }
      local percentage = function()
        local row = vim.fn.line(".")
        local total_rows = vim.fn.line("$")
        return string.format("%2d%%%%", 100 * row / total_rows)
      end
      local location = "%3l:%-2v"

      return MiniStatusline.combine_groups {
        {
          hl = mode_hl,
          strings = { mode },
        },
        {
          hl = "MiniStatuslineDevinfo",
          strings = { git, diagnostics },
        },
        "%<", -- Mark general truncate point
        {
          hl = "MiniStatuslineFilename",
          strings = { filename },
        },
        "%=", -- End left alignment
        {
          hl = "StatusLineMode",
          strings = { require("noice").api.status.mode.get() },
        },
        {
          hl = "MiniStatuslineFilename",
          strings = { fileinfo },
        },
        {
          hl = "MiniStatuslineFileinfo",
          strings = { percentage() },
        },
        {
          hl = mode_hl,
          strings = { search, location },
        },
      }
    end,
  },
}

--
-- mini.surround
--

require("mini.surround").setup()
