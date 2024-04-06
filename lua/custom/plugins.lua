local plugins = {
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({
        vim.api.nvim_set_hl(0, "blue",   { fg = "#3d59a1" });
        vim.api.nvim_set_hl(0, "green",  { fg = "#9ece6a" });
        vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" });
        vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" });

        vim.fn.sign_define('DapBreakpointCondition', { text='O', texthl='blue',   linehl='DapBreakpoint', numhl='DapBreakpoint' });
        vim.fn.sign_define('DapBreakpointRejected',  { text='O', texthl='orange', linehl='DapBreakpoint', numhl='DapBreakpoint' });
        vim.fn.sign_define('DapLogPoint',            { text='O', texthl='yellow', linehl='DapBreakpoint', numhl='DapBreakpoint' });
        vim.fn.sign_define('DapBreakpoint',
            {
                text='🔴', -- nerdfonts icon here
                texthl='DapBreakpointSymbol',
                linehl='DapBreakpoint',
                numhl='DapBreakpoint'
            });
        vim.fn.sign_define('DapStopped',
            {
                text='', -- nerdfonts icon here
                texthl='DapStoppedSymbol',
                linehl='DapBreakpoint',
                numhl='DapBreakpoint'
            });
        layouts = {
            {
              elements = {
              -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.29, max_size = 0.29 },
                -- "breakpoints",
                { id = "stacks", size = 0.5, max_size = 0.5},
                { id = "watches", size = 0.20, max_size = 0.20}
              },
              size = 60, -- 40 columns
              position = "right",
            },
            {
              elements = {
                "repl",
                "console",
              },
              size = 0.25, -- 25% of total lines
              position = "bottom",
            },
        },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "a",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
        },
        element_mappings = {
            stacks = {
              open = { "<CR>", "<2-LeftMouse>" }
            }
          },
      });
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require("core.utils").load_mappings("dap")
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",

    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
      }
    }
  },
  {
    "nvim-lua/plenary.nvim"
  },
  {
    "Shatur/neovim-tasks",
    dependencies = { "nvim-dap-ui" },
    config = function()
      local Path = require "plenary.path"
      require("tasks").setup {
        default_params = {
          -- Default module parameters with which `neovim.json` will be created.
          cmake = {
            cmd = "cmake",
            build_dir = tostring(Path:new("{cwd}", "build", "{os}-{build_type}")),
            build_type = "Debug",
            dap_name = "codelldb",
            args = {
              configure = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1", "-G", "Ninja" },
            },
          },
        },
        save_before_run = true, -- If true, all files will be saved before executing a task.
        params_file = "neovim.json", -- JSON file to store module and task parameters.
        quickfix = {
          pos = "botright", -- Default quickfix position.
          height = 12, -- Default height.
        },
        dap_open_command = false,
      }
    end,
    init = function()
      vim.keymap.set( "n", "<leader>cC", [[:Task start cmake configure<cr>]], { silent = true } )
      -- vim.keymap.set( "n", "<leader>cD", [[:Task start cmake_kits configureDebug<cr>]], { silent = true } )
      -- vim.keymap.set( "n", "<leader>cP", [[:Task start cmake_kits reconfigure<cr>]], { silent = true } )
      -- vim.keymap.set( "n", "<leader>cT", [[:Task start cmake_kits ctest<cr>]], { silent = true } )
      -- vim.keymap.set( "n", "<leader>cK", [[:Task start cmake_kits clean<cr>]], { silent = true } )
      -- vim.keymap.set( "n", "<leader>ct", [[:Task set_module_param cmake_kits target<cr>]], { silent = true } )
      -- vim.keymap.set( "n", "<C-c>", [[:Task cancel<cr>]], { silent = true } )
      vim.keymap.set( "n", "<leader>cr", [[:Task start cmake run<cr>]], { silent = true } )
      -- vim.keymap.set( "n", "<F7>", [[:Task start cmake_kits debug<cr>]], { silent = true } )
      vim.keymap.set( "n", "<leader>cb", [[:Task start cmake build<cr>]], { silent = true } )
      vim.keymap.set( "n", "<leader>cB", [[:Task start cmake build_all<cr>]], { silent = true } )
    end,
    cmd = { "Task" },
  },
  {
    -- Test interactions
    "nvim-neotest/neotest",
    dependencies = {
      'nvim-lua/plenary.nvim',
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
		  "Shatur/neovim-tasks",
  	  "amar-laksh/neotest-catch2",
      -- 'nvim-neotest/neotest-python',
      'alfaix/neotest-gtest',
      -- 'rosstang/neotest-catch2'
    },
    cmd = {
      "RunAllTestInDir"
    },
    config = function()
      vim.api.nvim_create_user_command("RunAllTestsInDir", function(args)
        local neotest = require("neotest");
        local path = args["args"]
        path = path:gsub('"','')
        neotest.run.run(path)
      end, {});
      lib = require("neotest.lib");
      require("neotest").setup({
        adapters = {
          -- require('neotest-catch2')(
          --  {
          --     args = {
          --       testSuffixes = {"_test"},
          --       tempDir = "/tmp/",
          --       buildPrefixes = {
          --         "/compile_commands.json",
          --         "/compile_flags.txt",
          --         "/.clangd",
          --       },
          --       runnerPrefix = "/home/as-lizin/trash/c++/shift-reduce-parser/build/Debug/tests/unit_tests"
          --     }
          -- });

          -- require("neotest-gtest").setup(
          --   {}
          -- );local utils = require("neotest-gtest.utils")

          require("neotest-gtest").setup({})
        }
      })

    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap",
    },
    init = function ()
      require("nvim-dap-virtual-text").setup {
          enabled = true,                        -- enable this plugin (the default)
          enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true,               -- show stop reason when stopped for exceptions
          commented = false,                     -- prefix virtual text with comment string
          only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
          all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
          clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
          --- A callback that determines how a variable is displayed or whether it should be omitted
          --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
          --- @param buf number
          --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
          --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
          --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
          --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
          display_callback = function(variable, buf, stackframe, node, options)
            if options.virt_text_pos == 'inline' then
              return ' = ' .. variable.value
            else
              return variable.name .. ' = ' .. variable.value
            end
          end,
          -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
          virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

          -- experimental features:
          all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                                 -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
  },
  {
    'tzachar/local-highlight.nvim',
     init = function()
      require('local-highlight').setup({
          file_types = {'python', 'cpp', 'lua'}, -- If this is given only attach to this
          -- OR attach to every filetype except:
          disable_file_types = {'tex'},
          hlgroup = 'Search',
          cw_hlgroup = nil,
          -- Whether to display highlights in INSERT mode or not
          insert_mode = true,
          min_match_len = 1,
          max_match_len = math.huge,
      })
    end
  },
  {
    "NvChad/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    opts = function()
      return require("custom.configs.nvterm")
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    init = function ()
      require('blame').setup({
        format = function(blame)
          return string.format("%s %s %s", blame.author, blame.date, blame.summary)
        end,
      })
    end
  }
}
return plugins
