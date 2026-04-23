local M = {}

function M.find_matches(pattern, explorer)
  local matches = {}

  local function search_recursive(node)
    if M.is_match(node, pattern) then
      table.insert(matches, {
        node = node,
        absolute_path = node.absolute_path,
      })
    end

    -- Only recurse into directories that are open (visible in the tree)
    if node.open and node.nodes then
      for _, child in ipairs(node.nodes) do
        search_recursive(child)
      end
    end
  end

  -- Explorer is the root node — iterate its nodes directly
  search_recursive(explorer)
  return matches
end

function M.is_match(node, pattern)
  if not pattern or pattern == "" then
    return false
  end

  local filename = vim.fn.fnamemodify(node.absolute_path, ":t")
  local pattern_lower = string.lower(pattern)
  local filename_lower = string.lower(filename)

  return vim.startswith(filename_lower, pattern_lower)
end

function M.ensure_parents_expanded(target_node, explorer)
  local parents = M.get_parent_nodes(target_node, explorer)

  for _, parent in ipairs(parents) do
    if not parent.open then
      parent.open = true
    end
  end

  -- Renderer is an instance on the explorer, not a standalone module
  explorer.renderer:draw()
end

function M.get_parent_nodes(target_node, explorer)
  local function find_path(node, target, path)
    if node == target then
      return path
    end
    if node.nodes then
      for _, child in ipairs(node.nodes) do
        local result = find_path(child, target, vim.list_extend({ node }, path))
        if result then
          return result
        end
      end
    end
    return nil
  end

  -- Pass explorer (root node object), not explorer.nodes (array)
  local path = find_path(explorer, target_node, {})
  if path then
    -- Remove the root explorer itself; it's always visible
    table.remove(path)
  end
  return path or {}
end

function M.focus_match(match, explorer)
  M.ensure_parents_expanded(match.node, explorer)

  local line = M.find_line_number(match.node, explorer)
  if line then
    local view = require("nvim-tree.view")
    view.set_cursor({ line, 0 })

    require("custom.nvim-tree-search.ui").apply_matches(
      require("custom.nvim-tree-search").get_state().matches,
      require("custom.nvim-tree-search").get_state().current_index
    )
  end
end

function M.find_line_number(target_node, explorer)
  -- Mirror builder.lua traversal: root is never counted, start at nodes_starting_line
  local line = require("nvim-tree.core").get_nodes_starting_line() - 1

  local function traverse(nodes)
    for _, node in ipairs(nodes) do
      if not node.hidden then
        line = line + 1
        if node == target_node then
          return true
        end
        -- Only recurse into open directories (mirrors renderer behaviour)
        if node.open and node.nodes then
          if traverse(node.nodes) then
            return true
          end
        end
      end
    end
    return false
  end

  -- Start at explorer.nodes, not explorer itself (root has no line)
  if traverse(explorer.nodes) then
    return line
  end
  return nil
end

function M.navigate_next(state)
  if #state.matches == 0 then
    return
  end

  state.current_index = state.current_index % #state.matches + 1
  M.focus_match(state.matches[state.current_index], require("nvim-tree.core").get_explorer())
end

function M.navigate_prev(state)
  if #state.matches == 0 then
    return
  end

  state.current_index = ((state.current_index - 2) % #state.matches) + 1
  M.focus_match(state.matches[state.current_index], require("nvim-tree.core").get_explorer())
end

return M
