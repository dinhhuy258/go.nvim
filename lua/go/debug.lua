local dap = require "go.dap"

local M = {}

function M.stop()
  dap.stop()
end

return M
