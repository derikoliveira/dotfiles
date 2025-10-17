local M = {}

---Create a blank line relative to the cursor position
---@param direction "above"|"below" Direction to create blank line from
local function create_blank_line_relative(direction)
  assert(direction == 'above' or direction == 'below', 'Direction must be "above" or "below"')

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1]
  if direction == 'above' then
    vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, { '' })
  else
    vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { '' })
  end
end

---Delete a blank line relative to the cursor position
---@param direction "above"|"below" Direction to delete blank line from
local function delete_blank_line_relative(direction)
  assert(direction == 'above' or direction == 'below', 'Direction must be "above" or "below"')

  local empty_line = '^%s*$'
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1]

  if direction == 'above' then
    local line_content = vim.api.nvim_buf_get_lines(0, current_line - 2, current_line - 1, false)[1]
    if line_content and line_content:match(empty_line) then
      vim.api.nvim_buf_set_lines(0, current_line - 2, current_line - 1, false, {})
    end
  else
    local line_content = vim.api.nvim_buf_get_lines(0, current_line, current_line + 1, false)[1]
    if line_content and line_content:match(empty_line) then
      vim.api.nvim_buf_set_lines(0, current_line, current_line + 1, false, {})
    end
  end
end

M.create_blank_line_relative = create_blank_line_relative
M.delete_blank_line_relative = delete_blank_line_relative

return M
