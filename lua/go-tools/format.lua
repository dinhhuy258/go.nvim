local utils = require "go-tools.utils"
local runner = require "go-tools.runner"

local M = {}

function M.format()
  -- TODO: Add config
  local args = { "golines", "--max-len=120", "--base-formatter=gofumpt", vim.api.nvim_buf_get_name(0) }

  runner.run("golines", function()
    runner.run("gofumpt", function()
      vim.fn.jobstart(args, {
        on_stdout = function(_, data, _)
          data = utils.handle_job_data(data)
          if not data then
            return
          end

          vim.api.nvim_buf_set_lines(0, 0, -1, false, data)
          vim.api.nvim_command "write"
        end,
        stdout_buffered = true,
        stderr_buffered = true,
      })
    end)
  end)
end

return M
