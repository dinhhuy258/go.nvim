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
end

return M
