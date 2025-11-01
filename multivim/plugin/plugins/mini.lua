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

mini_files = require("mini.files")

local never_show = {
  ".git",
  ".DS_Store",
}

local always_show = {
  ".editorconfig",
  "dummy_file.txt",
}

-- State
local hide_dotfiles = true
local hide_gitignored = true

-- Remove filesystem entries that are in gitignored
---@param fs_entries table
local function filter_and_sort(fs_entries)
  if hide_gitignored then
    local paths = table.concat(
      vim.tbl_map(function(entry)
        return entry.path
      end, fs_entries),
      "\n"
    )

    local result = vim
      .system({ "git", "check-ignore", "--stdin" }, { text = true, stdin = paths })
      :wait()

    -- Check for error code and empty stdout
    --
    -- 0: One or more of the provided paths is ignored.
    -- 1: None of the provided paths are ignored.
    -- 128: A fatal error was encountered.
    if result.code ~= 0 or not result.stdout then
      return fs_entries
    end

    local ignored_paths = vim.split(result.stdout, "\n")

    fs_entries = vim.tbl_filter(function(entry)
      return (
        not vim.tbl_contains(ignored_paths, entry.path)
        or vim.tbl_contains(always_show, entry.name)
      )
    end, fs_entries)
  end

  return mini_files.default_sort(fs_entries)
end

local function filter(fs_entry)
  return not vim.tbl_contains(never_show, fs_entry.name)
    and not (
      hide_dotfiles
      and vim.startswith(fs_entry.name, ".")
      and not vim.tbl_contains(always_show, fs_entry.name)
    )
end

local function highlight(fs_entry)
  if vim.startswith(fs_entry.name, ".") then
    return "Comment"
  end
end
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    vim.keymap.set("n", "g.", function()
      hide_gitignored = not hide_gitignored
      hide_dotfiles = not hide_dotfiles
      MiniFiles.refresh { content = { filter = filter, sort = filter_and_sort } }
    end, { buffer = args.data.buf_id })
  end,
})

mini_files.setup {
  content = {
    filter = filter,
    sort = filter_and_sort,
    highlight = highlight,
  },
}

vim.keymap.set("n", "-", mini_files.open)

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
  query_updaters = "",
}

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "MiniStarterOpened",
  callback = function(args)
    vim.keymap.del("n", "<M-j>", { buffer = args.buf })
    vim.keymap.del("n", "<M-k>", { buffer = args.buf })
    vim.keymap.del("n", "<C-n>", { buffer = args.buf })
    vim.keymap.del("n", "<C-p>", { buffer = args.buf })
    vim.keymap.set("n", "j", function()
      require("mini.starter").update_current_item("next")
    end, { buffer = args.buf })
    vim.keymap.set("n", "k", function()
      require("mini.starter").update_current_item("prev")
    end, { buffer = args.buf })
    vim.keymap.set("n", "e", function()
      require("mini.starter").set_query("Edit new buffer")
    end, { buffer = args.buf })
    vim.keymap.set("n", "q", function()
      require("mini.starter").set_query("Quit Neovim")
    end, { buffer = args.buf })
  end,
})

--
-- mini.statusline
--

vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { link = "DiffText" })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { link = "Cursor" })

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
          hl = "Constant",
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
