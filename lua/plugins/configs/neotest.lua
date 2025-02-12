
      require("neotest").setup({
        adapters = {
          require("neotest-gtest").setup({

            filter_dir = function(name, rel_path, root)
              return name ~= "googletest"
            end,
          }),
          require("neotest-boost-test")
        }
      })
