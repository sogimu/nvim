local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

-- nvimtree
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>")
map("n", "<C-h>", "<cmd> NvimTreeFocus <CR>")

-- telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>")
map("n", "<leader>tr", "<cmd> Telescope resume <CR>")

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>")
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>")
map("n", "<C-q>", "<cmd> bd <CR>")

-- comment.nvim
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- format
map("n", "<leader>fm", function()
  require("conform").format()
end)

-- indent
map("v", ">", ">gv", { remap = true })
map("v", "<", "<gv", { remap = true })
    
-- map("n", "gD",
--   function()
--     vim.lsp.buf.declaration()
--   end
-- )
--
-- map("n", "gd",
--       function()
--         vim.lsp.buf.definition()
--       end
-- )
--
-- map("n", "K",
--       function()
--         vim.lsp.buf.hover()
--       end
-- )
--
-- map("n", "gi",
--        -- function()
--          -- vim.lsp.buf.implementation()
--         "<Cmd> ClangdSwitchSourceHeader <CR>"
--       -- end
-- )
--
-- map("n", "<leader>ls",
--       function()
--         vim.lsp.buf.signature_help()
--       end
-- )
--
-- map("n", "<leader>D",
--       function()
--         vim.lsp.buf.type_definition()
--       end
-- )
--
-- map("n", "<leader>ra",
--       function()
--         require("nvchad.renamer").open()
--       end
-- )
--
-- map("n", "<leader>ca",
--       function()
--         vim.lsp.buf.code_action()
--       end
-- )
--
-- map("n", "gr",
--       function()
--         vim.lsp.buf.references()
--       end
-- )
--
-- map("n", "<leader>lf",
--       function()
--         vim.diagnostic.open_float { border = "rounded" }
--       end
-- )
--
-- map("n", "[d",
--       function()
--         vim.diagnostic.goto_prev { float = { border = "rounded" } }
--       end
-- )
--
-- map("n", "]d",
--       function()
--         vim.diagnostic.goto_next { float = { border = "rounded" } }
--       end
-- )
--
-- map("n", "<leader>q",
--       function()
--         vim.diagnostic.setloclist()
--       end 
-- )
--
-- map("n", "<leader>wa",
--       function()
--         vim.lsp.buf.add_workspace_folder()
--       end
-- )
--
-- map("n", "<leader>wr",
--       function()
--         vim.lsp.buf.remove_workspace_folder()
--       end
-- )
--
-- map("n", "<leader>wl",
--       function()
--         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--       end
-- )

map("t", "<A-i>","<cmd> ToggleTerm direction=float <CR>"
    -- function()
      -- require("nvterm.terminal").toggle "float"
    -- end
)

    map("n", "<A-i>","<cmd> ToggleTerm direction=float <CR>"
      -- function()
      --   -- require("nvterm.terminal").toggle "float"
      -- end
)

map( "n", "<leader>cC", "<cmd> Task start cmake configure <CR>" )
-- map( "n", "<leader>cD", [[:Task start cmake_kits configureDebug<cr>]], { silent = true } )
-- map( "n", "<leader>cP", [[:Task start cmake_kits reconfigure<cr>]], { silent = true } )
-- map( "n", "<leader>cT", [[:Task start cmake_kits ctest<cr>]], { silent = true } )
-- map( "n", "<leader>cK", [[:Task start cmake_kits clean<cr>]], { silent = true } )
-- map( "n", "<leader>ct", [[:Task set_module_param cmake_kits target<cr>]], { silent = true } )
-- map( "n", "<C-c>", [[:Task cancel<cr>]], { silent = true } )
map( "n", "<leader>cr", "<cmd> Task start cmake run <CR>" )
-- map( "n", "<F7>", [[:Task start cmake_kits debug<cr>]] )
map( "n", "<leader>cb", "<cmd> Task start cmake build <CR>" )
map( "n", "<leader>cB", "<cmd> Task start cmake build_all <CR>" )

    map( "n", "<F26>",  -- CTRL+F2
      "<cmd> DapTerminate <CR>"
      -- "Terminate debugger",
    ) 
    map( "n", "<F32>",  -- CTRL+F8
      "<cmd> DapToggleBreakpoint <CR>"
      -- "Add breakpoint at line",
    ) 
    map( "n", "<F9>",  -- F9
      "<cmd> CMakeDebug <CR>"
      -- "Start debugger"
    ) 
    map( "n", "<F21>",  -- SHIFT+F9
      "<cmd> DapContinue <CR>"
      -- "Continue the debugger"
    ) 
    map( "n", "<F8>",  -- F8
      "<cmd> DapStepOver <CR>"
      -- "Step over line"
    ) 
    map( "n", "<F7>",  --F7
      "<cmd> DapStepInto <CR>"
      -- "Step into line"
    ) 
    map( "n", "<S-a>",  -- RUN ALL TESTS 
      function()
        local neotest = require("neotest");
        -- local path = "/home/as-lizin/develop/shift-reduce-parser/tests/unit_tests/src"
        local path = vim.fn.getcwd()
        print( path )
        neotest.run.run(path)
      end
      -- "Run all tests",
    ) 
    map( "n", "<S-l>",  -- RUN LAST TEST 
      function()
        local neotest = require("neotest");
        neotest.run.run_last()
      end
      -- "Run last test",
    ) 
    map( "n", "<S-f>",  -- RUN ALL TESTS IN CURRENT FILE
      function()
        local neotest = require("neotest");
        local run = neotest.run;
        print(vim.fn.expand("%"));
        run.run(vim.fn.expand("%"))
      end
      -- "Run all tests in file",
    ) 

    map( "n", "<S-t>",  -- RUN NEAREST TEST IN CURRENT FILE
      function()
        local neotest = require('neotest');
        neotest.run.run();
      end
      -- "Run nearest test",
    ) 
    map( "n", "<S-d>",  -- DEBUG NEAREST TEST IN CURRENT FILE
      function()
        local neotest = require('neotest');
        neotest.run.run({strategy = "dap"});
      end
      -- "Debug nearest test",
    ) 
    map( "n", "<S-s>",  -- OPEN NEOTEST SUMMARY PANEL
      function()
        local neotest = require('neotest');
        if is_test_settings_open then
          neotest.summary.close()
          is_test_settings_open = false
        else
          neotest.summary.open()
          is_test_settings_open = true
        end
      end
      -- "Toggle tests settings",
    ) 
