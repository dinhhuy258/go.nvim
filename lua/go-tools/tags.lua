local M = {}

local gomodify = "gomodifytags"

local function modify(...)
  require("go-tools.install").install(gomodify)

  local fname = vim.fn.expand "%"
  local struct_name = require("go-tools.utils.treesitter").get_current_struct()
  if not struct_name then
    vim.notify "Struct not found"
    return
  end

  local cmd = { gomodify, "-format", "json", "-file", fname, "-struct", struct_name, "-w" }

  local arg = { ... }
  for _, v in ipairs(arg) do
    table.insert(cmd, v)
  end

  if #arg == 1 and arg[1] ~= "clear-tags" then
    table.insert(cmd, "json")
  end

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      data = require("go-tools.utils").handle_job_data(data)
      if not data then
        return
      end
      local tagged = vim.fn.json_decode(data)

      if tagged.errors ~= nil or tagged.lines == nil or tagged["start"] == nil or tagged["start"] == 0 then
        vim.notify("Failed to set tags" .. vim.inspect(tagged))
      end
      vim.api.nvim_buf_set_lines(0, tagged["start"] - 1, tagged["start"] - 1 + #tagged.lines, false, tagged.lines)
      vim.cmd "write"
    end,
  })
end

function M.add(...)
  local cmd = { "-add-tags" }
  local arg = { ... }
  for _, v in ipairs(arg) do
    table.insert(cmd, v)
  end

  modify(unpack(cmd))
end

function M.remove(...)
  local cmd = { "-remove-tags" }
  local arg = { ... }
  for _, v in ipairs(arg) do
    table.insert(cmd, v)
  end

  modify(unpack(cmd))
end

function M.clear()
  modify(unpack { "-clear-tags" })
end

return M
