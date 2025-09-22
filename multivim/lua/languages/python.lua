local function format(bufnr)
  vim.lsp.buf.code_action {
    context = { only = { "source.organizeImports" } },
    apply = true,
  }
  vim.wait(100)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "ruff"
    end,
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.lsp.enable("ruff")
vim.lsp.config("ruff", {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = format_on_save_callback,
    })
  end,
})

vim.lsp.enable("pyright")
vim.lsp.config("pyright", {
  on_attach = function(client, bufnr)
    client.handlers["textDocument/publishDiagnostics"] = function(...) end
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })
  end,
})

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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "python",
  callback = function(args)
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.b[args.buf].format_on_save = true

    vim.g.cell_delimiter = "^#\\s\\=%%"
    vim.g.cells_highlight_from = "Comment"

    vim.api.nvim_buf_create_user_command(
      0,
      "ReplStart",
      start_repl,
      { nargs = 1 }
    )
  end,
})
