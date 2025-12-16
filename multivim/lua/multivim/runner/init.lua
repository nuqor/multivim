local localconf = require("multivim.localconf")
local wezterm = require("multivim.wezterm")

local M = {}

---@param cmd string|string[]
function M.run_in_terminal(cmd)
  vim.cmd.tabnew()

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, exit_code, _)
      if exit_code ~= 0 then
        vim.notify(
          "Runner exited with code " .. tostring(exit_code),
          vim.log.levels.ERROR
        )
      end
    end,
  })

  local terminal_buffer_id = vim.api.nvim_get_current_buf()

  vim.keymap.set("n", "q", function()
    vim.api.nvim_buf_delete(terminal_buffer_id, { force = true })
  end, { buffer = terminal_buffer_id })
end

---@param cmd string
function M.run_in_pane(cmd, bufnr)
  bufnr = bufnr or 0

  local pane_id = vim.b[bufnr].multivim_runner_pane_id
  if pane_id and not wezterm.pane_exists(pane_id) then
    pane_id = nil
  end

  if pane_id == nil then
    pane_id = wezterm.split_pane {
      direction = "bottom",
      percent = 30,
      focus_new_pane = false,
    }
    vim.b[bufnr].multivim_runner_pane_id = pane_id
  else
  end

  if cmd == nil then
    return
  end

  wezterm.send_text(pane_id, cmd .. "\n", false)
end

function M.run_code()
  local cmd = localconf.get("run_command")
  if cmd ~= nil then
    cmd = cmd:gsub("${file}", vim.fn.expand("%:p"))
    M.run_in_pane(cmd)
  else
    vim.notify("run_command not found in multivim config")
  end
end

return M
