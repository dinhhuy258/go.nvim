local config = require "go.config"

local M = {}

function M.setup(opts)
  config.setup(opts)

  vim.cmd [[command! -nargs=* GoAddTags lua require("go.tags").add(<f-args>)]]
  vim.cmd [[command! -nargs=* GoRemoveTags lua require("go.tags").remove(<f-args>)]]
  vim.cmd [[command! GoClearTags lua require("go.tags").clear()]]

  vim.cmd [[command! GoTest lua require("go.tests").run_test()]]
  vim.cmd [[command! GoTests lua require("go.tests").run_tests()]]
  vim.cmd [[command! GoAddTest lua require("go.tests").add_test()]]
  vim.cmd [[command! GoAddTests lua require("go.tests").add_tests()]]

  vim.cmd [[command! GoDapInstall lua require("go.dap").install()]]

  vim.cmd [[command! GoDebugStop lua require("go.debug").stop()]]

  vim.cmd [[command! -nargs=* GoMake lua require("go.cmd").cmd('make', <f-args>)]]
  vim.cmd [[command! -nargs=* Go lua require("go.cmd").cmd('go', <f-args>)]]

  vim.cmd [[command! GoSwitch lua require("go.switch").switch()]]

  vim.cmd [[command! GoFormat lua require("go.format").format()]]

  require("go.dap").config()
end

return M
