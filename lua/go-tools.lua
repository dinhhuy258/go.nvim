local M = {}

function M.setup()
  vim.cmd [[command! -nargs=* GoAddTag lua require("go-tools.tags").add(<f-args>)]]
  vim.cmd [[command! -nargs=* GoRmTag lua require("go-tools.tags").remove(<f-args>)]]
  vim.cmd [[command! GoClearTag lua require("go-tools.tags").clear()]]

  vim.cmd [[command! GoTest lua require("go-tools.tests").run_test()]]
  vim.cmd [[command! GoTests lua require("go-tools.tests").run_tests()]]
  vim.cmd [[command! GoAddTest lua require("go-tools.tests").add_test()]]
  vim.cmd [[command! GoAddTests lua require("go-tools.tests").add_tests()]]

  vim.cmd [[command! GoInstallDap lua require("go-tools.dap").install()]]
  vim.cmd [[command! GoUninstallDap lua require("go-tools.dap").uninstall()]]
  vim.cmd [[command! GoConfigDap lua require("go-tools.dap").config()]]

  vim.cmd [[command! GoDebugStart lua require("go-tools.dap").run()]]
  vim.cmd [[command! GoDebugStop lua require("go-tools.dap").stop()]]
  vim.cmd [[command! GoDebugTest lua require("go-tools.dap").run('test')]]

  vim.cmd [[command! -nargs=* GoMake lua require("go-tools.cmd").cmd('make', <f-args>)]]
  vim.cmd [[command! -nargs=* Go lua require("go-tools.cmd").cmd('go', <f-args>)]]

  vim.cmd [[command! GoSwitch lua require("go-tools.switch").switch()]]

  require("go-tools.dap").config()
end

return M
