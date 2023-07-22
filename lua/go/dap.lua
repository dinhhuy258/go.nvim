local runner = require "go.runner"

local M = {}

local dap_config = {
  configurations = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      showLog = false,
      program = "${file}",
      dlvToolPath = vim.fn.exepath "dlv",
    },
    {
      type = "go",
      name = "Debug test",
      request = "launch",
      showLog = false,
      mode = "test",
      program = "${file}",
      dlvToolPath = vim.fn.exepath "dlv",
    },
  },
}

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
      initialize_timeout_sec = 10,
    },
  }

  dap.configurations.go = dap_config.configurations
end

function M.install()
  runner.install("dlv", function()
    -- empty function
  end)
end

function M.run(mode)
  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    return
  end

  if mode == "test" then
    dap.run(dap_config.configurations[2]) -- Test mode is in index 2
  else
    dap.run(dap_config.configurations[1]) -- Non test mode is in index 1
  end
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
