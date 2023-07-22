local config = require "go.config"
local runner = require "go.runner"

local M = {}

function M.config()
  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    return
  end

  -- setup dap
  local port = "${port}"
  local args = { "dap", "-l", "127.0.0.1:" .. port }

  dap.adapters.go = {
    type = "server",
    port = port,
    executable = {
      command = "dlv",
      args = args,
    },
    options = {
      initialize_timeout_sec = config.opts.dap.timeout,
      max_retries = config.opts.dap.retries,
    },
  }

  dap.configurations.go = config.opts.dap.configurations
end

function M.install()
  runner.install("dlv", function()
    -- empty function
  end)
end

function M.stop()
  local dap_ok, dap = pcall(require, "dap")
  if dap_ok then
    dap.disconnect()
    dap.close()
    dap.repl.close()
  end

  local dapui_ok, dapui = pcall(require, "dapui")
  if dapui_ok then
    dapui.close()
  end
end

return M
