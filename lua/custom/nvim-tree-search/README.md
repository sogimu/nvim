# Nvim-Tree Search Plugin

## Overview

Custom search plugin for NvimTree that provides fast file/directory navigation with keyboard shortcuts.

## Features

- **Quick Search**: Press `Ctrl+S` in NvimTree to open search overlay
- **Real-time Matching**: Results update as you type
- **Navigation**: Use arrow keys to navigate between matches
- **Smart Cursor**: Cursor stays on selected item after Enter
- **Normal Mode**: Automatically returns to Normal mode after selection

## Usage

### Starting Search
1. Focus the NvimTree window
2. Press `Ctrl+S` to open search overlay
3. Type to search for files/directories (case-insensitive prefix matching)

### Navigation
- `↓` / `↑` - Navigate between matches
- `Enter` - Open file or expand directory, cursor stays on selection
- `Esc` - Cancel search, return to original position
- `Ctrl+U` - Clear search input

## Implementation

### Files Structure
```
lua/custom/nvim-tree-search/
├── init.lua     # Main module and state management
├── search.lua   # Search logic and navigation
└── ui.lua       # Overlay UI and keymaps
```

### Key Components

#### State Management (`init.lua`)
```lua
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
```

#### Search Algorithm (`search.lua`)
- Recursive search through visible tree nodes
- Case-insensitive prefix matching
- Only searches in expanded directories

#### UI Overlay (`ui.lua`)
- Minimal floating window overlay
- Real-time text change handling
- Custom highlights for matches

## Key Fix: Cursor Position Issue

### Problem
When pressing Enter after navigating to a match:
1. Cursor would jump back to original position
2. Mode stayed in Insert
3. `state.matches` was cleared before being used

### Solution
1. **Modified `stop()` function**: Added `restore_cursor` parameter
2. **Updated `open_current_match()`**: 
   - Store match before stopping
   - Call `stop(false)` to prevent cursor restoration
   - Explicitly set Normal mode with `vim.cmd("stopinsert")`

### Code Changes

#### init.lua
```lua
function M.stop(restore_cursor)
  restore_cursor = restore_cursor ~= false -- Default to true
  
  -- ... cleanup code ...
  
  if restore_cursor and tree_win and vim.api.nvim_win_is_valid(tree_win) then
    vim.api.nvim_win_set_cursor(tree_win, state.original_cursor)
  end
end
```

#### ui.lua
```lua
function M.open_current_match(state)
  if state.current_index > 0 and state.current_index <= #state.matches then
    local match = state.matches[state.current_index]
    local node = match.node
    
    -- Stop without restoring cursor
    require("custom.nvim-tree-search").stop(false)
    
    -- Handle file/directory
    require("nvim-tree.api").node.open.edit(node)
    
    -- Ensure Normal mode
    vim.cmd("stopinsert")
  end
end
```

## API Reference

### Main Functions

#### `M.start()`
Initialize search overlay and enter Insert mode.

#### `M.stop(restore_cursor)`
Close overlay and clean up state.
- `restore_cursor`: boolean (default true) - whether to restore original cursor position

#### `M.navigate(direction)`
Navigate between matches.
- `direction`: "next" or "prev"

### Search Functions

#### `M.find_matches(pattern, explorer)`
Return array of matching nodes.

#### `M.focus_match(match, explorer)`
Navigate tree to show and highlight match.

### UI Functions

#### `M.create_overlay()`
Create floating search window.

#### `M.setup_highlights()`
Define custom highlight groups.

#### `M.apply_matches(matches, current_index)`
Highlight all matches with special highlight for current.

## Configuration

### Highlight Groups
```lua
NvimTreeSearchMatch    # Regular matches
NvimTreeSearchCurrent  # Current selected match
```

### Keymaps
All keymaps are buffer-local to the overlay window:
- `<CR>`: Open current match
- `<Esc>`: Cancel search
- `<C-u>`: Clear input
- `<Down>`: Next match
- `<Up>`: Previous match

## Dependencies

- `nvim-tree.view` - Window management
- `nvim-tree.core` - Tree explorer access
- `nvim-tree.api` - Node operations

## Testing

Test scenarios:
1. Search for file, press Enter → cursor stays, Normal mode
2. Search for directory, press Enter → expands, cursor stays, Normal mode
3. Navigate with arrows, press Esc → returns to original position
4. Search with no matches → no crash

## Future Enhancements

- Fuzzy matching instead of prefix
- Search in file contents
- Persistent search history
- Customizable keymaps