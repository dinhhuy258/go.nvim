local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

local function get_node_at_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_range = { cursor[1] - 1, 32 } -- Hack to set col to 32
  local root = ts_utils.get_root_for_position(unpack(cursor_range))
  if not root then
    return
  end

  return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

local function get_current_node(type)
  local current_node = get_node_at_cursor()

  while current_node do
    if current_node:type() == type then
      break
    end
    current_node = current_node:parent()
  end

  return current_node
end

function M.get_current_struct()
  local current_node = get_current_node "struct_type"

  if current_node then
    return vim.trim(ts_utils.get_node_text(current_node:parent())[1]):gmatch "%w+"()
  end
end

function M.get_current_function()
  local current_node = get_current_node "function_declaration"

  if current_node then
    return vim.trim(ts_utils.get_node_text(current_node)[1]):gsub("func ", ""):gmatch "%w+"()
  end

  current_node = get_current_node "method_declaration"
  if current_node == nil then
    return
  end

  local method_declaration = vim.trim(ts_utils.get_node_text(current_node)[1]):gsub("func .*\\s.*", "")
  local idx, _ =  string.find(method_declaration, ")")
  if idx == nil then
    return
  end

  return vim.trim(string.sub(method_declaration, idx + 1)):gmatch "%w+"()
end

return M
