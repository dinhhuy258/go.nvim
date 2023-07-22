local M = {}

function M.log(message)
  vim.notify("[go.nvim] " .. message)
end

function M.is_test_file(file)
  return file:sub(-string.len "_test.go") == "_test.go"
end

M.handle_job_data = function(data)
  if not data then
    return nil
  end
  if data[#data] == "" then
    table.remove(data, #data)
  end
  if #data < 1 then
    return nil
  end
  return data
end

return M
