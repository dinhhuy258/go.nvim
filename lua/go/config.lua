local M = {
  opts = {},
}

local default_config = {
  dap = {
    timeout = 15,
    retries = 20,
    configurations = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        showLog = false,
        program = "${file}",
        dlvToolPath = vim.fn.exepath "dlv",
      },
      {
        type = "go",
        name = "Debug test",
        request = "launch",
        showLog = false,
        mode = "test",
        program = "${file}",
        dlvToolPath = vim.fn.exepath "dlv",
      },
    },
  },
}

---@param opts table
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", default_config, opts or {})
end

return M
