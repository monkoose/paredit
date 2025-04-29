local M = {}

local nvim_buf_get_lines = vim.api.nvim_buf_get_lines
local nvim_win_get_cursor = vim.api.nvim_win_get_cursor
local nvim_win_set_cursor = vim.api.nvim_win_set_cursor

---@param linenr integer
---@return integer
local function line_indent_size(linenr)
   local linestr = nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
   local _, size = string.find(linestr, "^%s*")
   return size ---@diagnostic disable-line: return-type-mismatch
end

---Reindent form and adjust cursor position
---If `linenr` is present, then additionally reindent to this line
---@param linenr? integer
function M.reindent_form(linenr)
   local pos = nvim_win_get_cursor(0)
   local old_indent = line_indent_size(pos[1])

   vim.cmd("normal! =ib")
   if linenr then vim.cmd("normal! =" .. linenr .. "G") end

   local new_indent = line_indent_size(pos[1])
   pos[2] = pos[2] + new_indent - old_indent
   nvim_win_set_cursor(0, pos)
end

return M
