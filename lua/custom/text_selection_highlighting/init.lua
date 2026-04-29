local M = {}

-- Setup highlight groups
local bgs = {
  "#556622", -- 1
  "#226677", -- 2
  "#772277", -- 3
  "#775522", -- 4
  "#225522", -- 5
}
local colors = {}
for i, bg in ipairs(bgs) do
  vim.api.nvim_set_hl(0, "HlMark" .. i, { bg = bg, fg = "#e0e0e0", default = true })
  table.insert(colors, "HlMark" .. i)
end

local ns = vim.api.nvim_create_namespace("hlmarks")

M.marks = {}        -- M.marks[bufnr] = { {extmark_ids, row, col}, ... }
M.last_color = 1
M.current_idx = {}

local function get_ranges()
  local bufnr = vim.api.nvim_get_current_buf()
  local s_row = vim.fn.line("v")
  local e_row = vim.fn.line(".")
  local s_col = vim.fn.col("v")
  local e_col = vim.fn.col(".")

  if s_row > e_row or (s_row == e_row and s_col > e_col) then
    s_row, e_row = e_row, s_row
    s_col, e_col = e_col, s_col
  end

  local ranges = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, s_row - 1, e_row, false)

  for i, line in ipairs(lines) do
    local row = s_row + i - 1
    local len = string.len(line)
    local col = (i == 1) and math.min(s_col, len + 1) or 1
    local end_c
    if row == e_row then
      end_c = math.min(e_col, len + 1)
    else
      end_c = len + 1
    end

    if col <= end_c then
      table.insert(ranges, {
        start_row = row - 1,
        start_col = col - 1,
        end_row = row - 1,
        end_col = end_c
      })
    end
  end
  return ranges
end

function M.highlight()
  local bufnr = vim.api.nvim_get_current_buf()
  local ranges = get_ranges()
  if #ranges == 0 then return end

  local input = vim.fn.input(string.format("Color (1-5) [Enter=%d]: ", M.last_color))
  local idx = tonumber(input) or M.last_color
  idx = math.max(1, math.min(5, idx))
  M.last_color = idx
  
  local group = colors[idx]
  local ids = {}

  for _, r in ipairs(ranges) do
    local id = vim.api.nvim_buf_set_extmark(bufnr, ns, r.start_row, r.start_col, {
      end_row = r.end_row,
      end_col = r.end_col,
      hl_group = group,
      strict = false,
      priority = 10,
    })
    table.insert(ids, id)
  end

  if not M.marks[bufnr] then M.marks[bufnr] = {} end
  table.insert(M.marks[bufnr], { extmark_ids = ids, row = ranges[1].start_row + 1, col = ranges[1].start_col })
  M.current_idx[bufnr] = #M.marks[bufnr]

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
end

function M.clear()
  local bufnr = vim.api.nvim_get_current_buf()
  if not M.marks[bufnr] then return end
  
  for _, mark in ipairs(M.marks[bufnr]) do
    for _, id in ipairs(mark.extmark_ids) do
      pcall(vim.api.nvim_buf_del_extmark, bufnr, ns, id)
    end
  end
  M.marks[bufnr] = nil
  M.current_idx[bufnr] = nil
end

local function jump(direction)
  local bufnr = vim.api.nvim_get_current_buf()
  local groups = M.marks[bufnr]
  if not groups or #groups == 0 then return end
  
  local idx = M.current_idx[bufnr] or 1
  idx = idx + direction
  if idx > #groups then idx = 1 end
  if idx < 1 then idx = #groups end
  M.current_idx[bufnr] = idx
  
  local mark = groups[idx]
  if not mark then return end
  
  vim.api.nvim_win_set_cursor(0, { mark.row, mark.col })
  vim.cmd('normal! zz')
  vim.notify(string.format("Mark %d/%d", idx, #groups), vim.log.levels.INFO)
end

function M.next_mark() jump(1) end
function M.prev_mark() jump(-1) end

vim.keymap.set("v", "<leader>h", M.highlight, { desc = "Highlight" })
vim.keymap.set("n", "<leader>H", M.clear, { desc = "Clear" })
vim.keymap.set("n", "<leader>n", M.next_mark, { desc = "Next Mark" })
vim.keymap.set("n", "<leader>N", M.prev_mark, { desc = "Prev Mark" })

return M
