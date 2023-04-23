local utils = require "utils"
local neotest = require "neotest"

utils.map("n", "<leader>rts", "<cmd>lua require('neotest').summary.toggle()<CR>")
utils.map("n", "<leader>rto", "<cmd>lua require('neotest').output.open({ enter = true })<cr>")
utils.map("n", "<leader>rta", "<cmd>lua require('neotest').run.attach()<cr>")
utils.map("n", "<leader>rtn", "<cmd>lua require('neotest').run.run()<CR>")
utils.map("n", "<leader>rtf", "<cmd>lua require('neotest').run.run(vim.fn.expand '%')<CR>")
utils.map("n", "<leader>rtl", "<cmd>lua require('neotest').run.run_last()<CR>")
utils.map("n", "<leader>rtN", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>")
utils.map("n", "<leader>rtF", "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>")
utils.map("n", "<leader>rtL", "<cmd>lua require('neotest').run.run_last({strategy = 'dap'})<cr>")
utils.map("n", "<leader>rtS", "<cmd>lua require('neotest').run.stop()<cr>")

-- It can be integrated with overseer
require("neotest").setup {
  adapters = {
    require "neotest-python",
    require "neotest-vim-test" {
      ignore_file_types = { "python", "vim", "lua" },
    },
    require "neotest-rust",
    require "neotest-go",
  },
  consumers = {
    overseer = require "neotest.consumers.overseer",
  },
  overseer = {
    enabled = true,
    force_default = true,
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
