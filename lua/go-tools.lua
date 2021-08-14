local M = {}

function M.setup()
  vim.cmd [[command! -nargs=* GoAddTag lua require("go-tools.tags").add(<f-args>)]]
  vim.cmd [[command! -nargs=* GoRmTag lua require("go-tools.tags").remove(<f-args>)]]
  vim.cmd [[command! GoClearTag lua require("go-tools.tags").clear()]]

  vim.cmd [[command! GoTest lua require("go-tools.tests").run_test()]]
  vim.cmd [[command! GoAddTest lua require("go-tools.tests").add_test()]]
  vim.cmd [[command! GoAddTests lua require("go-tools.tests").add_tests()]]

  vim.cmd [[command! GoDapInstall lua require("go-tools.dap").dap_install()]]
  vim.cmd [[command! GoDapUninstall lua require("go-tools.dap").dap_uninstall()]]

  local status_ok, dap = pcall(require, "dap")
  if not status_ok then
    return
  end

  local dap_config = require("go-tools.dap").dap_config

  dap.adapters.go = dap_config.adapters
  dap.configurations.go = dap_config.configurations
end

return M
