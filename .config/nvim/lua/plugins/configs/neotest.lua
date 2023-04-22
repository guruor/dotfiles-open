local utils = require "utils"
local neotest = require "neotest"

utils.map("n", "<leader>rtn", ":lua require'neotest'.run.run()<CR>")
utils.map("n", "<leader>rtf", ":lua require'neotest'.run.run(vim.fn.expand '%')<CR>")
utils.map("n", "<leader>rta", ":lua require'neotest'.run.run 'src'<CR>")
utils.map("n", "<leader>rtl", ":lua require'neotest'.run.run_last()<CR>")
utils.map("n", "<leader>rts", ":lua require'neotest'.summary.toggle()<CR>")
utils.map("n", "<leader>rto", ":lua require'neotest'.output_panel.toggle()<CR>")

-- It can be integrated with overseer
require("neotest").setup {
  adapters = {
    require "neotest-python",
    require "neotest-go",
  },
  consumers = {
    overseer = require "neotest.consumers.overseer",
  },
  diagnostic = {
    enabled = true,
  },
  status = {
    enabled = true,
    signs = true,
    virtual_test = true,
  },
}
