
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
