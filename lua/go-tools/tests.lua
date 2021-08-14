local M = {}

local gotests = "gotests"

local function run_gotests(cmd)
  require("go-tools.install").install(gotests)

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, _, _)
      vim.notify "Unit tests was generated"
    end,
    on_stderr = function(_, _, _)
      vim.notify "Failed to generate unit test"
    end,
  })
end

function M.add_test()
  local function_name = require("go-tools.utils.treesitter").get_current_function()
  if not function_name then
    vim.notify "Function not found"
    return
  end

  local fpath = vim.fn.expand "%"
  local cmd = { gotests, "-w", "-only", function_name, fpath }

  run_gotests(cmd)
end

function M.run_test()
  local function_name = require("go-tools.utils.treesitter").get_current_function()

  if not function_name then
    vim.notify "Function not found"
    return
  end

  local fpath = vim.fn.expand "%:p:h"
  local cmd = [[setl makeprg=go\ test\ -v\ -run\ ^]]
    .. function_name
    .. [[\ ]]
    .. fpath
    .. [[ | lua require"go-tools.async_make".make() ]]

  vim.notify("Run test: " .. function_name)
  vim.cmd(cmd)
end

return M
