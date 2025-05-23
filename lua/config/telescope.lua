local telescope = require("telescope")
telescope.setup({
  defaults = {
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending",
  },
})

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })

