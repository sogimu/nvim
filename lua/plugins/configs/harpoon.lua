local harpoon = require('harpoon')
harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<A-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
vim.keymap.set("n", "<A-a>", function() harpoon:list():add() end, { desc = "Add current file to harpoon" })
vim.keymap.set("n", "<A-r>", function() harpoon:list():remove() end, { desc = "Remove current file from harpoon" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open quick harpoon window" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<A-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<A-S-N>", function() harpoon:list():next() end)
