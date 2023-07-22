local ts_utils = require "nvim-treesitter.ts_utils"
local ts_query = require "nvim-treesitter.query"
local parsers = require "nvim-treesitter.parsers"
local locals = require "nvim-treesitter.locals"

local M = {}

local query_func = [[((function_declaration name: (identifier)@function.name) @function.declaration)]]
local query_method_name =
  [[((method_declaration receiver: (parameter_list)@method.receiver name: (field_identifier)@method.name body:(block))@method.declaration)]]
local query_struct_block =
  [[((type_declaration (type_spec name:(type_identifier) @struct.name type: (struct_type)))@struct.declaration)]]
local query_em_struct_block =
  [[(field_declaration name:(field_identifier)@struct.name type: (struct_type)) @struct.declaration]]

local function get_current_node(query)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local bufnr = vim.api.nvim_get_current_buf()

  local ft = vim.api.nvim_buf_get_option(bufnr, "ft")

  local success, parsed_query = pcall(function()
    return vim.treesitter.query.parse(ft, query)
  end)
  if not success then
    return nil
  end

  local parser = parsers.get_parser(bufnr, ft)
  local root = parser:parse()[1]:root()
  local start_row, _, end_row, _ = root:range()
  for match in ts_query.iter_prepared_matches(parsed_query, root, bufnr, start_row, end_row) do
    local sRow, eRow
    local declaration_node
    local name = ""
    local op = ""

    locals.recurse_local_nodes(match, function(_, node, path)
      local idx = string.find(path, ".[^.]*$") -- find last .
      op = string.sub(path, idx + 1, #path)
      if op == "name" then
        name = ts_utils.get_node_text(node, bufnr)[1]
      elseif op == "declaration" or op == "clause" then
        declaration_node = node
        sRow, _, eRow, _ = node:range()
        sRow = sRow + 1
        eRow = eRow + 1
      end
    end)

    if declaration_node ~= nil then
      if sRow <= row and eRow >= row then
        return name
      end
    end
  end

  return nil
end

function M.get_current_struct()
  return get_current_node(query_struct_block .. " " .. query_em_struct_block)
end

function M.get_current_function()
  return get_current_node(query_func .. " " .. query_method_name)
end

return M
