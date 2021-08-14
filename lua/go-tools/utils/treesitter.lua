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

function M.get_current_struct()
  local current_node = get_node_at_cursor()

  while current_node do
    if current_node:type() == "struct_type" then
      current_node = current_node:parent()
      break
    end
    current_node = current_node:parent()
  end

  if current_node then
    return vim.trim(ts_utils.get_node_text(current_node)[1]):gmatch "%w+"()
  end
end

return M
