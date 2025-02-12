
      local Path = require "plenary.path"
      require("tasks").setup {
        default_params = {
          -- Default module parameters with which `neovim.json` will be created.
          cmake = {
            cmd = "cmake",
            build_dir = tostring(Path:new("{cwd}", "build", "{os}-{build_type}")),
            build_type = "Debug",
            dap_name = "lldb",
            args = {
              -- configure = { "-G", "Ninja", "-D", "CMAKE_TOOLCHAIN_FILE=./clang-toolchain.cmake" },
              configure = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1', '-G', 'Ninja' },
            },
          },
        },
        save_before_run = true, -- If true, all files will be saved before executing a task.
        params_file = "neovim.json", -- JSON file to store module and task parameters.
        quickfix = {
          pos = "botright", -- Default quickfix position.
          height = 12, -- Default height.
        },
        dap_open_command = function() return require('dap').repl.open() end,
      }
