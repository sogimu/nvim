local config = {
  terminals = {
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.1,
        col = 0.1,
        width = 0.85,
        height = 0.8,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.4 },
      vertical = { location = "rightbelow", split_ratio = 0.5 },
    },
  },
  behavior = {
    autoclose_on_quit = {
      enabled = true,
      confirm = true,
    },
    close_on_exit = true,
    auto_insert = true,
  }
}

return config;
