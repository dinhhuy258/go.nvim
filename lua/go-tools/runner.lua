local utils = require "go-tools.utils"

local M = {}

local DIR_SEP = package.config:sub(1, 1)

local urls = {
  gomodifytags = "github.com/fatih/gomodifytags",
  gotests = "github.com/cweill/gotests/...",
  gofumpt = "mvdan.cc/gofumpt",
  golines = "github.com/segmentio/golines",
}

local function is_installed(bin)
  local env_path = os.getenv "PATH"
  local base_paths = vim.split(env_path, ":", true)
  for _, value in pairs(base_paths) do
    if vim.loop.fs_stat(value .. DIR_SEP .. bin) then
      return true
    end
  end
  return false
end

local function go_install(bin, runnable)
  local url = urls[bin]
  if url == nil then
    utils.log("Command " .. bin .. " not supported")
    return
  end

  url = url .. "@latest"
  vim.fn.jobstart({ "go", "install", url }, {
    -- FIXME: Do we need to check the status of bin installation
    on_exit = function(_, _, _)
      utils.log(bin .. " has been installed")
      runnable()
    end,
  })
end

local function install(bin, runnable)
  if not is_installed(bin) then
    utils.log("Installing " .. bin .. "...")
    go_install(bin, runnable)
  end
end

function M.run(bin, runnable)
  if not is_installed(bin) then
    install(bin, runnable)
  else
    runnable()
  end
end

return M
