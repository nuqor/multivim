-- Filenames of config file candidates
local config_filenames = { "multivim.json", ".multivim.json" }

-- Use config filenames as root markers
-- Add .git to stop search at a git root directory
local root_markers = { config_filenames, ".git" }

-- Get the path of the first config file in the root directory
---@param root_directory string
---@return string? Path to config file or nil
local function get_config_filename(root_directory)
  for _, filename in ipairs(config_filenames) do
    local config_filename = vim.fs.joinpath(root_directory, filename)
    if vim.uv.fs_stat(config_filename) then
      return config_filename
    end
  end
  return nil
end

-- Read JSON config file and decode to table
---@param config_file string Path to config file
---@return table? Config or nil
local function read_json(config_file)
  local fp = io.open(config_file, "r")

  if not fp then
    vim.print(string.format("Could not open multivim config: %s", config_file))
    return nil
  end

  local json_content = fp:read("*all")
  fp:close()

  return vim.json.decode(json_content)
end

-- On event `BufRead`, try to find a config file in the parent directories.
-- On success, read the JSON config file and store a filtypes config, which is
-- glob matched, in a buffer-local variable `localconf`.
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(args)
    local root_directory = vim.fs.root(args.buf, root_markers)

    if not root_directory then
      return
    end

    local config_file = get_config_filename(root_directory)

    if not config_file then
      return
    end

    local json = read_json(config_file)

    if not json then
      return
    end

    local buffer_file_path = vim.fn.expand("%:p")

    for pattern, options in pairs(json) do
      local test_pattern = vim.fs.joinpath(root_directory, pattern)
      local lpeg_pattern = vim.glob.to_lpeg(test_pattern)
      if lpeg_pattern:match(buffer_file_path) then
        vim.b[args.buf].localconf = options
      end
    end
  end,
})

--
-- Public
--

local M = {}

---@class ConfigGetOpts
---@field buffer integer
---@field default any

---@param key string
---@param opts ConfigGetOpts?
function M.get(key, opts)
  opts = opts or {}
  local bufnr = opts["buffer"] or 0

  local config = vim.b[bufnr].localconf

  if not config or config[key] == nil then
    return opts["default"]
  end

  return config[key]
end

return M
