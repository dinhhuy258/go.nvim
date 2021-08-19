local utils = require "go-tools.utils"
local dap = require "go-tools.dap"

local M = {}

function M.start()
  local fpath = vim.fn.expand "%:p"
  if not utils.is_test_file(fpath) then
    dap.run()
  else
    dap.run "test"
  end
end

function M.stop()
  dap.stop()
end

return M
