local register_formatter = require("languages").register_formatter
local localconf = require("multivim.localconf")

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

vim.lsp.enable("ruff")
vim.lsp.config("ruff", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  on_attach = function(client, bufnr)
    register_formatter(bufnr, format)
  end,
})

vim.lsp.enable("pyright")
vim.lsp.config("pyright", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    python = {
      analysis = {
        diagnosticMode = "workspace",
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Disable diagnostics in favor of ruff
    client.handlers["textDocument/publishDiagnostics"] = function(...) end
  end,
})

local function mypy_callback(args)
  local enable_mypy = localconf.get("enable_mypy", {
    buffer = args.buf,
    default = false,
  })
  if enable_mypy then
    require("lint").try_lint("mypy")
  end
end

local function get_mpl_backends_path()
  return os.getenv("MPL_BACKENDS_PATH")
    or vim.fn.stdpath("config") .. "/python/mpl_backends"
end

local ipython_command = table.concat({
  'PYTHONPATH="' .. get_mpl_backends_path() .. ':${PYTHONPATH}"',
  'MPLBACKEND="module://wezterm"',
  "MPLBACKEND_WEZTERM_FIGURE_RELATIVE_WIDTH=80",
  "ipython --no-banner --no-autoindent",
}, " ")

local function send_command(cmd)
  vim.fn["slime#send"](cmd .. "\r")
end

local function clear_terminal()
  vim.fn["slime#send"]("\x0c")
end

-- direction: left, right
local function start_repl(direction, width_in_cells)
  local terminal_pane_id = require("multivim.wezterm").split_pane {
    direction = direction,
    focus_new_pane = false,
  }

  -- Configure slime with wezterms pane id
  local slime_config = vim.b[0].slime_config or {}
  slime_config.pane_id = terminal_pane_id
  vim.b[0].slime_config = slime_config

  send_command("cd " .. vim.fn.expand("%:p:h"))
  send_command(ipython_command)
  send_command('__file__ = "' .. vim.fn.expand("%:p") .. '"')
  clear_terminal()
end

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "python",
  callback = function(args)
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      buffer = args.buf,
      callback = mypy_callback,
    })

    vim.b[args.buf].slime_cell_delimiter = "^#\\s*%%"

    vim.api.nvim_buf_create_user_command(0, "ReplStartTo", function(args)
      start_repl(args.fargs[1], args.fargs[2])
    end, { nargs = "+" })

    vim.api.nvim_buf_create_user_command(0, "ReplStart", function()
      start_repl("left", 80)
    end, { nargs = 0 })

    require("multivim.cells").register(args.buf, {
      cell_delimiter = "# %%",
      cell_delimiter_regex = "^#\\s*%%",
    })
  end,
})
