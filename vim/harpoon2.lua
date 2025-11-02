local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

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

vim.keymap.set("n", "<space>h", function() toggle_telescope(harpoon:list()) end,
  { desc = "Open harpoon window" })

vim.keymap.set("n", "<space>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<space>l", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

for i = 1, 9 do
  vim.keymap.set("n", "<space>" .. i, function() harpoon:list():select(i) end)
end

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "[h", function() harpoon:list():prev() end)
vim.keymap.set("n", "]h", function() harpoon:list():next() end)
