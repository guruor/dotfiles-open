-- Add this if needed
-- TODO: Add https://github.com/Weissle/persistent-breakpoints.nvim

local dap = require "dap"
-- Enable virutal text, requires rcarriga/nvim-dap-ui
local dapui = require "dapui"
dapui.setup {
  -- icons = { expanded = "?", collapsed = "?" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  layouts = {
    {
      elements = {
        { id = "breakpoints", size = 0.20 },
        { id = "watches", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "scopes", size = 0.30 },
      },
      size = 40,
      position = "right",
    },
    {
      elements = { "repl" },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
}
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Loading the breakpoints
require('persistent-breakpoints').setup{
	load_breakpoints_event = { "BufReadPost" }
}

-- Enable virutal text, requires theHamsta/nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup()
vim.g.dap_virtual_text = true
