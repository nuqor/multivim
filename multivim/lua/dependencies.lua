local M = {}

function M.is_nix_native()
  return (tonumber(os.getenv("NVIM_NIX_NATIVE")) or 0) == 1
end

function M.install_mini_deps()
  if not M.is_nix_native() then
    local path_package = vim.fn.stdpath("data") .. "/site/"
    local mini_path = path_package .. "pack/deps/start/mini.nvim"
    if not vim.uv.fs_stat(mini_path) then
      vim.cmd('echo "Installing `mini.nvim`" | redraw')
      local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/echasnovski/mini.nvim",
        mini_path,
      }
      vim.fn.system(clone_cmd)
      vim.cmd("packadd mini.nvim | helptags ALL")
      vim.cmd('echo "Installed `mini.nvim`" | redraw')
    end
    require("mini.deps").setup { path = { package = path_package } }
  end
end

function M.add(args)
  if not M.is_nix_native() then
    MiniDeps.add(args)
  end
end

function M.later(func)
  if not M.is_nix_native() then
    MiniDeps.later(func)
  else
    func()
  end
end

return M
