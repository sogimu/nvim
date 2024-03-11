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
    ["<S-f>"] = { -- RUN ALL GTESTS IN CURRENT FILE
      function()
        local neotest = require("neotest");
        local run = neotest.run;
        run.run(vim.fn.expand("%"))
      end,
      "Run all tests in file",
    },

    ["<S-t>"] = { -- RUN NEAREST GTEST IN CURRENT FILE
      function()
        local neotest = require('neotest');
        neotest.run.run();
      end,
      "Run nearest test",
    },
    ["<S-d>"] = { -- DEBUG NEAREST GTEST IN CURRENT FILE
      function()
        local neotest = require('neotest');
        neotest.run.run({strategy = "dap"});
      end,
      "Debug nearest test",
    },
    ["<S-s>"] = { -- RUN NEAREST GTEST IN CURRENT FILE
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
