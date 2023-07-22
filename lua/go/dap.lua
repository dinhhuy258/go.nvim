local utils = require "go.utils"

local M = {}

local installation_path = vim.fn.stdpath "data" .. "/dapinstall/"
local dbg_path = installation_path .. "go/"

local dap_installer = {
  install = [[
		git clone https://github.com/go-delve/delve && cd delve
		go install github.com/go-delve/delve/cmd/dlv
		cd ..
		git clone https://github.com/golang/vscode-go && cd vscode-go
    sudo npm install
		sudo npm run compile
	]],
}

local dap_config = {
  adapters = {
    type = "executable",
    command = "node",
    args = { dbg_path .. "vscode-go/dist/debugAdapter.js" },
  },
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

  dap.adapters.go = dap_config.adapters
  dap.configurations.go = dap_config.configurations
end

function M.install()
  if vim.fn.confirm("Do you want to install the go debugger?", "&Yes\n&Cancel") ~= 1 then
    return
  end

  if vim.fn.isdirectory("" .. dbg_path .. "") == 1 then
    vim.fn.delete("" .. dbg_path .. "", "rf")
  end

  vim.fn.mkdir("" .. dbg_path .. "", "p")
  vim.cmd "new"
  local shell = vim.o.shell
  vim.o.shell = "/bin/bash"

  vim.fn.termopen("set -e\n" .. dap_installer["install"], {
    ["cwd"] = dbg_path,
    ["on_exit"] = function(_, code)
      if code ~= 0 then
        error "Could not install the go debugger!"
      else
        print "Successfully installed the go debugger!"
      end
    end,
  })

  vim.o.shell = shell
  vim.cmd "startinsert"
end

function M.uninstall()
  if vim.fn.isdirectory("" .. dbg_path .. "") ~= 1 then
    return
  end

  if vim.fn.confirm("Do you want to uninstall the go debugger?", "&Yes\n&Cancel") ~= 1 then
    return
  end

  vim.fn.delete("" .. dbg_path .. "", "rf")
  utils.log "Successfully uninstalled the go debugger!"
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
