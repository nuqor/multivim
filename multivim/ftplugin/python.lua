vim.g.cell_delimiter = "^#\\s\\=%%"
vim.g.cells_highlight_from = "Comment"

local function get_mpl_backends_path()
  return os.getenv("MPL_BACKENDS_PATH")
    or vim.fn.stdpath("config") .. "/python/mpl_backends"
end

local ipython_command = table.concat({
  'PYTHONPATH="' .. get_mpl_backends_path() .. ':${PYTHONPATH}"',
  'MPLBACKEND="module://wezterm"',
  "MPLBACKEND_WEZTERM_FIGURE_RELATIVE_WIDTH=80",
  "ipython --no-banner",
}, " ")

-- direction: left, right
local function start_repl(args)
  local direction = args.fargs[1]

  local mux = require("smart-splits.mux").get()

  -- Split terminal, get wezterms pane id and return to original pane
  mux.split_pane(direction)
  local terminal_pane_id = mux.current_pane_id()
  vim.fn.system { "wezterm", "cli", "activate-pane-direction", "Prev" }

  -- Configure slime with wezterms pane id
  local slime_config = vim.b[0].slime_config or {}
  slime_config.pane_id = terminal_pane_id
  vim.b[0].slime_config = slime_config

  print(ipython_command)

  -- Send command to start ipyhton and clear terminal
  vim.fn.system {
    "wezterm",
    "cli",
    "send-text",
    "--pane-id",
    tostring(terminal_pane_id),
    "--no-paste",
    ipython_command .. "\r",
  }
  vim.fn.system {
    "wezterm",
    "cli",
    "send-text",
    "--pane-id",
    tostring(terminal_pane_id),
    "--no-paste",
    "\x0c",
  }
end

vim.api.nvim_buf_create_user_command(0, "ReplStart", start_repl, { nargs = 1 })
