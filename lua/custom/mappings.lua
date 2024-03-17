local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<F26>"] = { -- CTRL+F2
      "<cmd> DapTerminate <CR>",
      "Terminate debugger",
    },
    ["<F32>"] = { -- CTRL+F8
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<F9>"] = { -- F9
      "<cmd> CMakeDebug <CR>",
      "Start debugger"
    },
    ["<F21>"] = { -- SHIFT+F9
      "<cmd> DapContinue <CR>",
      "Continue the debugger"
    },
    ["<F8>"] = { -- F8
      "<cmd> DapStepOver <CR>",
      "Step over line"
    },
    ["<F7>"] = { --F7
      "<cmd> DapStepInto <CR>",
      "Step into line"
    },
    ["<S-a>"] = { -- RUN ALL TESTS 
      function()
        local neotest = require("neotest");
        -- local path = "/home/as-lizin/develop/shift-reduce-parser/tests/unit_tests/src"
        local path = vim.fn.getcwd()
        print( path )
        neotest.run.run(path)
      end,
      "Run all tests",
    },
    ["<S-l>"] = { -- RUN LAST TEST 
      function()
        local neotest = require("neotest");
        neotest.run.run_last()
      end,
      "Run last test",
    },
    ["<S-f>"] = { -- RUN ALL TESTS IN CURRENT FILE
      function()
        local neotest = require("neotest");
        local run = neotest.run;
        print(vim.fn.expand("%"));
        run.run(vim.fn.expand("%"))
      end,
      "Run all tests in file",
    },

    ["<S-t>"] = { -- RUN NEAREST TEST IN CURRENT FILE
      function()
        local neotest = require('neotest');
        neotest.run.run();
      end,
      "Run nearest test",
    },
    ["<S-d>"] = { -- DEBUG NEAREST TEST IN CURRENT FILE
      function()
        local neotest = require('neotest');
        neotest.run.run({strategy = "dap"});
      end,
      "Debug nearest test",
    },
    ["<S-s>"] = { -- RUN NEAREST TEST IN CURRENT FILE
      function()
        local neotest = require('neotest');
        if is_test_settings_open then
          neotest.summary.close()
          is_test_settings_open = false
        else
          neotest.summary.open()
          is_test_settings_open = true
        end
      end,
      "Toggle tests settings",
    },
  }
}

return M
