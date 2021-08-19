local utils = require "go-tools.utils"

local M = {}

function M.switch()
  local file = vim.fn.expand "%"

  local alt_file = ""
  if utils.is_test_file(file) then
    alt_file = vim.fn.split(file, "_test.go")[1] .. ".go"
  else
    alt_file = vim.fn.split(file, ".go")[1] .. "_test.go"
  end

  if not vim.fn.filereadable(alt_file) and not vim.fn.bufexists(alt_file) then
    utils.log("Couldn't open " .. alt_file)
    return
  end

  vim.cmd("e " .. alt_file)
end

return M
