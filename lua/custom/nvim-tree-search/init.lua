local M = {}

local state = {
  active = false,
  pattern = "",
  matches = {},
  current_index = 0,
  original_cursor = {},
  overlay_buf = nil,
  overlay_win = nil,
  highlight_ns = nil,
}

function M.get_state()
  return state
end

function M.start()
  if state.active then
    return
  end

  local view = require("nvim-tree.view")
  local tree_win = view.get_winnr()

  if not tree_win or not vim.api.nvim_win_is_valid(tree_win) then
    vim.notify("NvimTree window not found", vim.log.levels.WARN)
    return
  end

  state.original_cursor = vim.api.nvim_win_get_cursor(tree_win)
  state.active = true

  require("custom.nvim-tree-search.ui").setup_highlights()

  local buf, win = require("custom.nvim-tree-search.ui").create_overlay()

  if not buf or not win then
    vim.notify("Failed to create search overlay", vim.log.levels.ERROR)
    state.active = false
    return
  end

  state.overlay_buf = buf
  state.overlay_win = win

  require("custom.nvim-tree-search.ui").setup_overlay_keymaps(buf, state)

  vim.cmd("startinsert!")
end

function M.stop()
  if not state.active then
    return
  end

  state.active = false

  if state.overlay_win and vim.api.nvim_win_is_valid(state.overlay_win) then
    vim.api.nvim_win_close(state.overlay_win, true)
  end

  if state.overlay_buf and vim.api.nvim_buf_is_valid(state.overlay_buf) then
    vim.api.nvim_buf_delete(state.overlay_buf, { force = true })
  end

  require("custom.nvim-tree-search.ui").clear_highlights(state)

  local view = require("nvim-tree.view")
  local tree_win = view.get_winnr()

  if tree_win and vim.api.nvim_win_is_valid(tree_win) then
    vim.api.nvim_win_set_cursor(tree_win, state.original_cursor)
  end

  state.pattern = ""
  state.matches = {}
  state.current_index = 0
  state.overlay_buf = nil
  state.overlay_win = nil
  state.highlight_ns = nil
end

function M.is_active()
  return state.active
end

function M.navigate(direction)
  if direction == "next" then
    require("custom.nvim-tree-search.search").navigate_next(state)
  elseif direction == "prev" then
    require("custom.nvim-tree-search.search").navigate_prev(state)
  end
end

return M
