return {
  -- Configure the explorer
  explorer = {
    enabled = true,
    -- Show hidden files by default
    hidden = true,
    -- Ignore patterns
    ignored = {
      ".git",
      "node_modules",
      "__pycache__",
      ".pytest_cache",
      ".vscode",
      ".idea",
    },
    -- Follow symlinks
    follow = true,
    -- Show directories first
    dirs_first = true,
    -- Auto cd to selected directory
    auto_cd = false,
  },
  -- Configure the picker
  picker = {
    enabled = true,
    sources = {
      files = {
        -- Show hidden files by default
        hidden = true,
        -- Ignore patterns
        ignored = {
          ".git",
          "node_modules",
          "__pycache__",
          ".pytest_cache",
          ".vscode",
          ".idea",
        },
      },
    },
    -- Key mappings within the picker
    win = {
      -- Window options
      input = {
        prompt = "🔍 ",
      },
    },
    -- Layout options
    layout = {
      preset = "vscode",
    },
    -- Ensure icons are properly configured
    icons = {
      files = {
        enabled = true,
        dir = "󰉋 ",
        dir_open = "󰝰 ",
        file = "󰈔 "
      },
    },
  },
  -- Configure other snacks features if needed
  bigfile = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}