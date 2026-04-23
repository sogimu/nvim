local M = {}

function M.create_overlay()
  local view = require("nvim-tree.view")
  local tree_win = view.get_winnr()
  local tree_buf = view.get_bufnr()

  if not tree_win or not tree_buf then
    return nil, nil
  end

  local width = vim.api.nvim_win_get_width(tree_win)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "win",
    win = tree_win,
    row = 0,
    col = 0,
    width = width,
    height = 1,
    style = "minimal",
    border = "single",
  })

  vim.api.nvim_set_option_value("filetype", "NvimTreeSearch", { buf = buf })
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })

  return buf, win
end

function M.setup_overlay_keymaps(buf, state)
  local opts = { buffer = buf, noremap = true, silent = true, nowait = true }

  vim.keymap.set("i", "<CR>", function()
    M.open_current_match(state)
  end, opts)

  vim.keymap.set("i", "<Esc>", function()
    require("custom.nvim-tree-search").stop(true)
    vim.cmd("stopinsert")
  end, opts)

  -- <C-u>: clear whole search line (default insert <C-u> only clears to cursor)
  vim.keymap.set("i", "<C-u>", function()
    vim.api.nvim_set_current_line("")
  end, opts)

  vim.keymap.set("i", "<Down>", function()
    require("custom.nvim-tree-search.search").navigate_next(state)
  end, opts)

  vim.keymap.set("i", "<Up>", function()
    require("custom.nvim-tree-search.search").navigate_prev(state)
  end, opts)

  -- <BS> is intentionally NOT overridden — Neovim handles it correctly in insert mode

  vim.api.nvim_create_autocmd("TextChangedI", {
    buffer = buf,
    callback = function()
      M.on_text_changed(state)
    end,
  })
end

function M.on_text_changed(state)
  local pattern = vim.api.nvim_get_current_line()

  state.pattern = pattern

  local explorer = require("nvim-tree.core").get_explorer()
  if not explorer then
    return
  end

  local matches = require("custom.nvim-tree-search.search").find_matches(pattern, explorer)

  state.matches = matches

  if #matches > 0 then
    state.current_index = 1
    require("custom.nvim-tree-search.search").focus_match(matches[1], explorer)
  else
    M.clear_highlights(state)
  end
end

function M.open_current_match(state)
  if state.current_index > 0 and state.current_index <= #state.matches then
    local match = state.matches[state.current_index]
    
    -- Store the match before stopping to avoid clearing it
    local node = match.node
    
    -- Stop search overlay without restoring cursor
    require("custom.nvim-tree-search").stop(false)
    
    -- Handle differently for files vs directories
    if node.nodes then
      -- Directory: expand/toggle in tree, keep cursor on it
      require("nvim-tree.api").node.open.edit(node)
    else
      -- File: open normally
      require("nvim-tree.api").node.open.edit(node)
    end
    
    -- Ensure we're in Normal mode
    vim.cmd("stopinsert")
  end
end

function M.setup_highlights()
  vim.api.nvim_set_hl(0, "NvimTreeSearchMatch", {
    fg = "#d19a66",
    bold = true,
    underline = true,
  })

  vim.api.nvim_set_hl(0, "NvimTreeSearchCurrent", {
    fg = "#61afef",
    bold = true,
    underline = true,
    bg = "#282c34",
  })
end

function M.apply_matches(matches, current_index)
  local view = require("nvim-tree.view")
  local buf = view.get_bufnr()
  if not buf then
    return
  end

  local ns = vim.api.nvim_create_namespace("nvim-tree-search")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local explorer = require("nvim-tree.core").get_explorer()
  if not explorer then
    return
  end

  for i, match in ipairs(matches) do
    local line = require("custom.nvim-tree-search.search").find_line_number(match.node, explorer)
    if line then
      local hl_group = (i == current_index) and "NvimTreeSearchCurrent" or "NvimTreeSearchMatch"
      vim.api.nvim_buf_add_highlight(buf, ns, hl_group, line - 1, 0, -1)
    end
  end
end

function M.clear_highlights(state)
  local view = require("nvim-tree.view")
  local buf = view.get_bufnr()
  if not buf then
    return
  end

  local ns = vim.api.nvim_create_namespace("nvim-tree-search")
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

return M
