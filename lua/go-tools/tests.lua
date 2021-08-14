local M = {}

function M.run_test()
  local fpath = vim.fn.expand "%:p:h"
  local function_name = require("go-tools.utils.treesitter").get_current_function()

  if not function_name then
    vim.notify "Function not found"
    return
  end

  local cmd = [[setl makeprg=go\ test\ -v\ -run\ ^]]
    .. function_name
    .. [[\ ]]
    .. fpath
    .. [[ | lua require"go-tools.async_make".make() ]]

  vim.notify("Run test: " .. function_name)
  vim.cmd(cmd)
end

return M
