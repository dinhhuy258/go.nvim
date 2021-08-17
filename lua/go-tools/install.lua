local M = {}

local DIR_SEP = package.config:sub(1, 1)

local urls = {
  gomodifytags = "github.com/fatih/gomodifytags",
  gotests = "github.com/cweill/gotests/...",
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

local function go_install(bin)
  local url = urls[bin]
  if url == nil then
    vim.notify("Command " .. bin .. " not supported")
    return
  end

  url = url .. "@latest"
  vim.fn.jobstart({ "go", "install", url }, {
    on_stdout = function(_, data, _)
      vim.notify(data)
    end,
  })
end

function M.install(bin)
  if not is_installed(bin) then
    vim.notify("Installing " .. bin .. "...")
    go_install(bin)
  end
end

return M
