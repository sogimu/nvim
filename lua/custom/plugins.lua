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
    "https://github.com/nvim-neotest/nvim-nio",
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
  },
  {
    "sindrets/diffview.nvim",
    init = function ()
      local actions = require("diffview.actions")

      require("diffview").setup({
        diff_binaries = false,    -- Show diffs for binaries
        enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
        git_cmd = { "git" },      -- The git executable followed by default args.
        hg_cmd = { "hg" },        -- The hg executable followed by default args.
        use_icons = true,         -- Requires nvim-web-devicons
        show_help_hints = true,   -- Show hints for how to open the help panel
        watch_index = true,       -- Update views and index buffers when the git index changes.
        icons = {                 -- Only applies when use_icons is true.
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          -- Configure the layout and behavior of different types of views.
          -- Available layouts:
          --  'diff1_plain'
          --    |'diff2_horizontal'
          --    |'diff2_vertical'
          --    |'diff3_horizontal'
          --    |'diff3_vertical'
          --    |'diff3_mixed'
          --    |'diff4_mixed'
          -- For more info, see ':h diffview-config-view.x.layout'.
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
            winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            layout = "diff3_horizontal",
            disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
            winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
            winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
          },
        },
        file_panel = {
          listing_style = "tree",             -- One of 'list' or 'tree'
          tree_options = {                    -- Only applies when listing_style is 'tree'
            flatten_dirs = true,              -- Flatten dirs that only contain one single dir
            folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
          },
          win_config = {                      -- See ':h diffview-config-win_config'
            position = "left",
            width = 35,
            win_opts = {}
          },
        },
        file_history_panel = {
          log_options = {   -- See ':h diffview-config-log_options'
            git = {
              single_file = {
                diff_merges = "combined",
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
            hg = {
              single_file = {},
              multi_file = {},
            },
          },
          win_config = {    -- See ':h diffview-config-win_config'
            position = "bottom",
            height = 16,
            win_opts = {}
          },
        },
        commit_log_panel = {
          win_config = {   -- See ':h diffview-config-win_config'
            win_opts = {},
          }
        },
        default_args = {    -- Default args prepended to the arg-list for the listed commands
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},         -- See ':h diffview-config-hooks'
        keymaps = {
          disable_defaults = false, -- Disable the default keymaps
          view = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            { "n", "<tab>",       actions.select_next_entry,              { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",     actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
            { "n", "gf",          actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>",  actions.goto_file_split,                { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",     actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e",   actions.focus_files,                    { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",   actions.toggle_files,                   { desc = "Toggle the file panel." } },
            { "n", "g<C-x>",      actions.cycle_layout,                   { desc = "Cycle through available layouts." } },
            { "n", "[x",          actions.prev_conflict,                  { desc = "In the merge-tool: jump to the previous conflict" } },
            { "n", "]x",          actions.next_conflict,                  { desc = "In the merge-tool: jump to the next conflict" } },
            { "n", "<leader>co",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
            { "n", "<leader>ct",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
            { "n", "<leader>cb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
            { "n", "<leader>ca",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
            { "n", "dx",          actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
            { "n", "<leader>cO",  actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
            { "n", "<leader>cT",  actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
            { "n", "<leader>cB",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<leader>cA",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
            { "n", "dX",          actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
          },
          diff1 = {
            -- Mappings in single window diff layouts
            { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
          },
          diff2 = {
            -- Mappings in 2-way diff layouts
            { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
          },
          diff3 = {
            -- Mappings in 3-way diff layouts
            { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
            { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
            { "n",          "g?",   actions.help({ "view", "diff3" }),  { desc = "Open the help panel" } },
          },
          diff4 = {
            -- Mappings in 4-way diff layouts
            { { "n", "x" }, "1do",  actions.diffget("base"),            { desc = "Obtain the diff hunk from the BASE version of the file" } },
            { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
            { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
            { "n",          "g?",   actions.help({ "view", "diff4" }),  { desc = "Open the help panel" } },
          },
          file_panel = {
            { "n", "j",              actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>",         actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
            { "n", "k",              actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<up>",           actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<cr>",           actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
            { "n", "o",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
            { "n", "l",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>",  actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
            { "n", "-",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
            { "n", "s",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
            { "n", "S",              actions.stage_all,                      { desc = "Stage all entries" } },
            { "n", "U",              actions.unstage_all,                    { desc = "Unstage all entries" } },
            { "n", "X",              actions.restore_entry,                  { desc = "Restore entry to the state on the left side" } },
            { "n", "L",              actions.open_commit_log,                { desc = "Open the commit log panel" } },
            { "n", "zo",             actions.open_fold,                      { desc = "Expand fold" } },
            { "n", "h",              actions.close_fold,                     { desc = "Collapse fold" } },
            { "n", "zc",             actions.close_fold,                     { desc = "Collapse fold" } },
            { "n", "za",             actions.toggle_fold,                    { desc = "Toggle fold" } },
            { "n", "zR",             actions.open_all_folds,                 { desc = "Expand all folds" } },
            { "n", "zM",             actions.close_all_folds,                { desc = "Collapse all folds" } },
            { "n", "<c-b>",          actions.scroll_view(-0.25),             { desc = "Scroll the view up" } },
            { "n", "<c-f>",          actions.scroll_view(0.25),              { desc = "Scroll the view down" } },
            { "n", "<tab>",          actions.select_next_entry,              { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",        actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
            { "n", "gf",             actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>",     actions.goto_file_split,                { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",        actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
            { "n", "i",              actions.listing_style,                  { desc = "Toggle between 'list' and 'tree' views" } },
            { "n", "f",              actions.toggle_flatten_dirs,            { desc = "Flatten empty subdirectories in tree listing style" } },
            { "n", "R",              actions.refresh_files,                  { desc = "Update stats and entries in the file list" } },
            { "n", "<leader>e",      actions.focus_files,                    { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",      actions.toggle_files,                   { desc = "Toggle the file panel" } },
            { "n", "g<C-x>",         actions.cycle_layout,                   { desc = "Cycle available layouts" } },
            { "n", "[x",             actions.prev_conflict,                  { desc = "Go to the previous conflict" } },
            { "n", "]x",             actions.next_conflict,                  { desc = "Go to the next conflict" } },
            { "n", "g?",             actions.help("file_panel"),             { desc = "Open the help panel" } },
            { "n", "<leader>cO",     actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
            { "n", "<leader>cT",     actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
            { "n", "<leader>cB",     actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<leader>cA",     actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
            { "n", "dX",             actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
          },
          file_history_panel = {
            { "n", "g!",            actions.options,                     { desc = "Open the option panel" } },
            { "n", "<C-A-d>",       actions.open_in_diffview,            { desc = "Open the entry under the cursor in a diffview" } },
            { "n", "y",             actions.copy_hash,                   { desc = "Copy the commit hash of the entry under the cursor" } },
            { "n", "L",             actions.open_commit_log,             { desc = "Show commit details" } },
            { "n", "zR",            actions.open_all_folds,              { desc = "Expand all folds" } },
            { "n", "zM",            actions.close_all_folds,             { desc = "Collapse all folds" } },
            { "n", "j",             actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>",        actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
            { "n", "k",             actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
            { "n", "<up>",          actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
            { "n", "<cr>",          actions.select_entry,                { desc = "Open the diff for the selected entry." } },
            { "n", "o",             actions.select_entry,                { desc = "Open the diff for the selected entry." } },
            { "n", "<2-LeftMouse>", actions.select_entry,                { desc = "Open the diff for the selected entry." } },
            { "n", "<c-b>",         actions.scroll_view(-0.25),          { desc = "Scroll the view up" } },
            { "n", "<c-f>",         actions.scroll_view(0.25),           { desc = "Scroll the view down" } },
            { "n", "<tab>",         actions.select_next_entry,           { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>",       actions.select_prev_entry,           { desc = "Open the diff for the previous file" } },
            { "n", "gf",            actions.goto_file_edit,              { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>",    actions.goto_file_split,             { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf",       actions.goto_file_tab,               { desc = "Open the file in a new tabpage" } },
            { "n", "<leader>e",     actions.focus_files,                 { desc = "Bring focus to the file panel" } },
            { "n", "<leader>b",     actions.toggle_files,                { desc = "Toggle the file panel" } },
            { "n", "g<C-x>",        actions.cycle_layout,                { desc = "Cycle available layouts" } },
            { "n", "g?",            actions.help("file_history_panel"),  { desc = "Open the help panel" } },
          },
          option_panel = {
            { "n", "<tab>", actions.select_entry,          { desc = "Change the current option" } },
            { "n", "q",     actions.close,                 { desc = "Close the panel" } },
            { "n", "g?",    actions.help("option_panel"),  { desc = "Open the help panel" } },
          },
          help_panel = {
            { "n", "q",     actions.close,  { desc = "Close help menu" } },
            { "n", "<esc>", actions.close,  { desc = "Close help menu" } },
          },
        },
      })
    end
    
  }
}
return plugins
