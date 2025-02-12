-- mason, write correct names only
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd "MasonInstall clangd stylua prettier clang-format codelldb"
end, {})

vim.api.nvim_create_user_command("RunAllTestsInDir", function(args)
  local neotest = require("neotest");
  local path = args["args"]
  path = path:gsub('"','')
  neotest.run.run(path)
end, {})
