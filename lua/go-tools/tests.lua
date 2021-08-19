local utils = require "go-tools.utils"

local M = {}

local gotests = "gotests"

local function run_gotests(cmd)
  require("go-tools.install").install(gotests)

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, _, _)
      utils.log "Unit tests was generated"
    end,
    on_stderr = function(_, _, _)
      utils.log "Failed to generate unit tests"
    end,
  })
end

function M.add_test()
  local function_name = require("go-tools.utils.treesitter").get_current_function()
  if not function_name then
    utils.log "Function not found"
    return
  end

  local fpath = vim.fn.expand "%"
  local cmd = { gotests, "-w", "-only", function_name, fpath }

  run_gotests(cmd)
end

function M.add_tests()
  local fpath = vim.fn.expand "%"
  local cmd = { gotests, "-all", "-w", fpath }

  run_gotests(cmd)
end

function M.run_test()
  if not utils.is_test_file(vim.fn.expand "%:p") then
    utils.log "No tests found. Current file is not a test file."
    return
  end

  local function_name = require("go-tools.utils.treesitter").get_current_function()
  if not function_name then
    utils.log "Not test function found"
    return
  end

  utils.log("Run test: " .. function_name)
  require("go-tools.cmd").cmd("go", "test -v -run ^" .. function_name .. " " .. vim.fn.expand "%:p:h")
end

function M.run_tests()
  local fpath = vim.fn.expand "%:p"
  if not utils.is_test_file(fpath) then
    utils.log "No tests found. Current file is not a test file."
    return
  end

  utils.log("Run test: " .. fpath)
  require("go-tools.cmd").cmd("go", "test -v -run ^ " .. fpath)
end

return M
