local dap_status_ok, dap = pcall(require, 'dap')
if not dap_status_ok then
    return
end

local dap_ui_status_ok, dapui = pcall(require, 'dapui')
if not dap_ui_status_ok then
    return
end

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
  -- dapui.open()
  dap.repl.open { height = 15 }
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  -- dapui.close()
  dap.repl.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  -- dapui.close()
  dap.repl.close()
end
