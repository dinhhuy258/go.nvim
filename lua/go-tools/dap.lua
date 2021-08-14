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

M.dap_config = {
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

function M.dap_install()
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

function M.dap_uninstall()
  if vim.fn.isdirectory("" .. dbg_path .. "") ~= 1 then
    return
  end

  if vim.fn.confirm("Do you want to uninstall the go debugger?", "&Yes\n&Cancel") ~= 1 then
    return
  end

  vim.fn.delete("" .. dbg_path .. "", "rf")
  vim.notify "Successfully uninstalled the go debugger!"
end

return M
