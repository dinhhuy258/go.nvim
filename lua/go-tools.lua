local M = {}

function M.setup()
  vim.cmd [[command! -nargs=* GoAddTags lua require("go-tools.tags").add(<f-args>)]]
  vim.cmd [[command! -nargs=* GoRemoveTags lua require("go-tools.tags").remove(<f-args>)]]
  vim.cmd [[command! GoClearTags lua require("go-tools.tags").clear()]]

  vim.cmd [[command! GoTest lua require("go-tools.tests").run_test()]]
  vim.cmd [[command! GoTests lua require("go-tools.tests").run_tests()]]
  vim.cmd [[command! GoAddTest lua require("go-tools.tests").add_test()]]
  vim.cmd [[command! GoAddTests lua require("go-tools.tests").add_tests()]]

  vim.cmd [[command! GoDapInstall lua require("go-tools.dap").install()]]
  vim.cmd [[command! GoDapUninstall lua require("go-tools.dap").uninstall()]]
  vim.cmd [[command! GoDapConfig lua require("go-tools.dap").config()]]

  vim.cmd [[command! GoDebugStart lua require("go-tools.debug").start()]]
  vim.cmd [[command! GoDebugStop lua require("go-tools.debug").stop()]]

  vim.cmd [[command! -nargs=* GoMake lua require("go-tools.cmd").cmd('make', <f-args>)]]
  vim.cmd [[command! -nargs=* Go lua require("go-tools.cmd").cmd('go', <f-args>)]]

  vim.cmd [[command! GoSwitch lua require("go-tools.switch").switch()]]

  vim.cmd [[command! GoFormat lua require("go-tools.format").format()]]

  require("go-tools.dap").config()
end

return M
