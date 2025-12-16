local M = {}

-- Run a system command synchronously.
---@param cmd string[] Command as array of strings
---@return string? Return stdout on success, otherwise `nil`
function M.system(cmd)
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    vim.notify(result.stderr or "", vim.log.levels.ERROR)
    return nil
  end
  return result.stdout or ""
end

-- Convenience function to run wezterm cli commands
---@param cmd string[] Command as array of strings
---@return string? Return stdout on success, otherwise `nil`
function M.wezterm_cli(cmd)
  table.insert(cmd, 1, "wezterm")
  table.insert(cmd, 2, "cli")
  return M.system(cmd)
end

-- Get the Pane ID of the currently active pane.
---@return string? Pane ID or `nil`
function M.get_current_pane_id()
  local json_string = M.wezterm_cli { "list-clients", "--format=json" }

  if not json_string then
    return nil
  end

  local clients = vim.json.decode(json_string)

  if not clients or #clients == 0 then
    return nil
  end

  return clients[1]["focused_pane_id"]
end

--- Get all Pane IDs
---@return int[] Currently existing Pane IDs
function M.get_pane_ids()
  local json_string = M.wezterm_cli { "list", "--format=json" }

  if not json_string then
    return nil
  end

  local panes = vim.json.decode(json_string)

  if not panes or #panes == 0 then
    return {}
  end

  pane_ids = {}
  for _, pane in pairs(panes) do
    table.insert(pane_ids, pane["pane_id"])
  end

  return pane_ids
end

--- Check if a Pane ID exists
--- @param pane_id int
--- @return boolean True if pane with given ID exists
function M.pane_exists(pane_id)
  for _, existing_pane_id in pairs(M.get_pane_ids()) do
    if existing_pane_id == pane_id then
      return true
    end
  end
  return false
end

---@enum Direction
local _Direction = {
  Right = "right",
  Top = "top",
  Left = "left",
  Bottom = "bottom",
}

-- Arguments analogously to `wezterm cli split-pane`.
-- Additionally, `focus_new_pane` allow to specify if the newly
-- created pane should focused (default).
---@class SplitPaneArgs
---@field direction Direction?
---@field percent integer?
---@field cells integer?
---@field cwd string?
---@field prog string?
---@field focus_new_pane boolean?

-- Create a new split pane
---@param args SplitPaneArgs
---@return number?
function M.split_pane(args)
  local cmd = { "split-pane" }

  if args.direction then
    table.insert(cmd, "--" .. args.direction)
  end

  if args.percent then
    table.insert(cmd, "--percent")
    table.insert(cmd, args.percent)
  end

  if args.cells then
    table.insert(cmd, "--cells")
    table.insert(cmd, args.cells)
  end

  if args.cwd then
    table.insert(cmd, "--cwd")
    table.insert(cmd, args.cwd)
  end

  if args.prog then
    table.insert(cmd, "--")
    table.insert(cmd, args.prog)
  end

  local new_pane_id = tonumber(M.wezterm_cli(cmd))

  if args.focus_new_pane ~= nil and not args.focus_new_pane then
    vim.fn.system { "wezterm", "cli", "activate-pane-direction", "Prev" }
  end

  return new_pane_id
end

-- Create a new pane the will fill the entire window
---@param prog string
function M.overlay_pane(prog)
  local pane_id = M.split_pane { prog = prog }
  M.wezterm_cli { "zoom-pane", "--pane-id", tostring(pane_id) }
end

-- Send text to wezterm pane
---@param pane_id integer
---@param text string
---@param bracketed_paste boolean? default: false
function M.send_text(pane_id, text, bracketed_paste)
  local cmd = { "send-text", "--pane-id", tostring(pane_id) }

  if bracketed_paste == nil then
    bracketed_paste = false
  end

  if not bracketed_paste then
    table.insert(cmd, "--no-paste")
  end

  table.insert(cmd, text)

  M.wezterm_cli(cmd)
end

return M
